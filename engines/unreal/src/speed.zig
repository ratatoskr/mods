//! Game speed through the world's time dilation, which Wraith asks for ahead of hooking the clocks.
//! Only the world slows down or speeds up, the UI and the camera manager carry on. 0 pauses the
//! world the engine's own way, as the local player. Games set the dilation themselves too, for
//! slow motion, so what the game sets is kept and ours goes on top.

const std = @import("std");
const sdk = @import("wraith_sdk");

const World = @import("ue/World.zig");

/// Within what `AWorldSettings` takes by default.
const min_dilation = 0.0001;
const max_dilation = 20;

pub const Speed = struct {
    world: ?*const World = null,
    /// Ours, as f64 bits, from Wraith on any thread.
    ours: sdk.atomic.Value(u64) = .init(@bitCast(@as(f64, 1))),
    /// Game thread only from here.
    settings: usize = 0,
    /// What the game has, under ours.
    game: f32 = 1,
    /// What we last wrote, to tell when the game changes it.
    written: ?f32 = null,
    /// The player state we paused with, if it's ours.
    paused_with: usize = 0,

    pub fn start(self: *Speed, world: *const World, game: sdk.api.wraith.Game) void {
        self.world = world;
        game.provideSpeed(.init(self, changed));
    }

    /// Puts the game's own back. Plain values, so any thread's fine.
    pub fn stop(self: *Speed) void {
        const world = self.world orelse return;
        self.ours.store(@bitCast(@as(f64, 1)), .release);
        if (self.settings == 0 or world.settings() != self.settings) return;
        const mem = world.ue.mem;
        if (self.written != null) _ = mem.write(f32, self.settings + world.off.time_dilation, self.game);
        if (self.paused_with != 0 and mem.ptr(self.settings + world.off.pauser) == self.paused_with) {
            _ = mem.write(usize, self.settings + world.off.pauser, 0);
        }
    }

    fn changed(self: *Speed, speed: f64) bool {
        self.ours.store(@bitCast(speed), .release);
        return true;
    }

    /// Game thread, once a tick. Each level load brings new world settings, so it checks.
    pub fn apply(self: *Speed) void {
        const world = self.world orelse return;
        const mem = world.ue.mem;
        const settings = world.settings() orelse return;
        if (settings != self.settings) {
            self.settings = settings;
            self.written = null;
            self.paused_with = 0;
        }
        const dilation_at = settings + world.off.time_dilation;
        const now = mem.read(f32, dilation_at) orelse return;
        // Not what we left, so the game's set its own
        if (self.written == null or now != self.written.?) self.game = now;
        const ours: f64 = @bitCast(self.ours.load(.acquire));

        const want = if (ours == 0) self.game else dilated(self.game, ours);
        if (want != now) _ = mem.write(f32, dilation_at, want);
        self.written = want;

        const pauser_at = settings + world.off.pauser;
        const pauser = mem.read(usize, pauser_at) orelse return;
        if (ours == 0) {
            if (pauser == 0) if (world.playerState()) |ps| {
                if (mem.write(usize, pauser_at, ps)) self.paused_with = ps;
            };
        } else if (self.paused_with != 0) {
            if (pauser == self.paused_with) _ = mem.write(usize, pauser_at, 0);
            self.paused_with = 0;
        }
    }
};

fn dilated(game: f32, ours: f64) f32 {
    if (std.math.isNan(game)) return game;
    return @floatCast(std.math.clamp(@as(f64, game) * ours, min_dilation, max_dilation));
}

test "ours goes on top of the game's, within what Unreal takes" {
    const testing = std.testing;
    try testing.expectEqual(2, dilated(1, 2));
    try testing.expectEqual(0.25, dilated(0.5, 0.5));
    try testing.expectEqual(max_dilation, dilated(4, 50));
    try testing.expectApproxEqAbs(min_dilation, dilated(1, 0.00001), 1e-9);
}
