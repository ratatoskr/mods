//! Game speed, through the slow rate manager's outermost group.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema").GranblueRelink;

const clock = @import("clock.zig");
const SlowRateManager = schema.SlowRateManager;
const Update = *const SlowRateManager.Fns.update;

/// The player and some bosses are outside the world's group, so it's the outermost.
const outermost = 0;

/// Longer than this without an update and the game loop's paused, like in Photo mode.
const paused_ns = 100 * std.time.ns_per_ms;

var started: ?*Speed = null;
var updated_at: i64 = 0;
var paused_after: i64 = 0;

/// Ticks from the camera while the game loop's paused.
pub fn tickIfPaused(now: i64) void {
    const self = started orelse return;
    if (self.ticks == null) return;
    if (now - updated_at > paused_after) sdk.threads.tick();
}

pub const Speed = struct {
    /// On the game's speed. Gets 1 as it's lost or let go.
    lease: ?sdk.Lease = null,

    /// As f32 bits.
    ours: sdk.atomic.Value(u32) = .init(@bitCast(@as(f32, 1))),
    update: Update = undefined,
    call: sdk.hooks.MidHook = undefined,
    ticks: ?sdk.Lease = null,

    pub fn start(self: *Speed, game: sdk.api.wraith.Game) !void {
        _ = try SlowRateManager.addresses.instance();
        self.update = @ptrFromInt(try SlowRateManager.addresses.update());
        self.call = try sdk.hooks.createMidWith(try SlowRateManager.addresses.update_call(), updateCall, self, .{ .replace = true, .size = 5, .expect = "E8 ?? ?? ?? ??", .enabled = true });
        self.lease = .{ .object = try game.claimSpeed(.init(self, changed), null) };
        paused_after = clock.ticks(paused_ns);
        updated_at = clock.now();
        started = self;
    }

    fn changed(self: *Speed, speed: f64) bool {
        self.ours.store(@bitCast(@as(f32, @floatCast(speed))), .release);
        return true;
    }

    /// Replaces the game loop's `call update`, as `update` itself can't be hooked.
    fn updateCall(self: *Speed, _: *sdk.api.CpuContext) void {
        updated_at = clock.now();
        if (self.ticks != null) sdk.threads.tick();
        const ours: f32 = @max(@as(f32, @bitCast(self.ours.load(.acquire))), 0);
        if (ours == 1) return self.update();
        const manager = (SlowRateManager.instance() catch null) orelse return self.update();
        const group = &manager.groups[outermost];
        const own = group.rate;
        group.rate = own * ours;
        self.update();
        group.rate = own;
        group.last_rate = own;
    }
};
