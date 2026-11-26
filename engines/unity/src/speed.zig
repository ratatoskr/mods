//! Game speed through Unity's `Time.timeScale`, which Wraith asks for ahead of hooking the clocks.
//! Only gameplay changes: UI, audio and anything on unscaled time carry on as they are, and 0 is a
//! clean pause. Games set the time scale themselves too, for pause menus, slow motion and hit-stop,
//! so what the game asks for is kept and ours goes on top. Reading it back gives the game its own,
//! so scripts that save and restore it don't stack ours up.

const std = @import("std");
const sdk = @import("wraith_sdk");

const W = sdk.api.wraith;
const log = sdk.log.scoped(.unity);

const SetScale = fn (f32) callconv(.c) void;
const GetScale = fn () callconv(.c) f32;

/// Unity won't go past it.
const max_scale = 100;
/// For `game`, before the main thread's read what the game has.
const unknown = std.math.maxInt(u32);

pub const Speed = struct {
    /// On the game's speed. Gets 1 as it's lost or let go.
    lease: ?sdk.Lease = null,
    set_hook: ?sdk.hooks.FnHook(SetScale) = null,
    /// Unity's setter itself, for putting the game's back
    set_at: usize = 0,
    get_hook: ?sdk.hooks.FnHook(GetScale) = null,
    /// Ours, as f64 bits, from Wraith on any thread
    ours: sdk.atomic.Value(u64) = .init(@bitCast(@as(f64, 1))),
    /// Ours changed since the main thread last put it on
    dirty: sdk.atomic.Value(bool) = .init(false),
    /// What the game last asked for, as f32 bits, or `unknown`
    game: sdk.atomic.Value(u32) = .init(unknown),

    /// Blocks while the game's runtime looks, so not on the render thread. Fails if this Unity's
    /// missing the calls, and then the clocks do it.
    pub fn start(self: *Speed, managed: W.Managed, game: W.Game) !void {
        const set_at = try managed.icall("UnityEngine.Time", "set_timeScale");
        self.set_at = set_at;
        const get_at = try managed.icall("UnityEngine.Time", "get_timeScale");
        // On once it holds the speed, which may be straight away
        self.set_hook = try sdk.hooks.createFnWith(SetScale, set_at, onSet, self, .{ .enabled = false });
        errdefer self.destroyHooks();
        self.get_hook = try sdk.hooks.createFnWith(GetScale, get_at, onGet, self, .{ .enabled = false });
        self.lease = .{ .object = try game.claimSpeed(.init(self, changed), .init(self, leaseChanged)) };
    }

    /// Puts the game's own time scale back. Unity's main thread can't, as Wraith skips the plugin's
    /// hooks while it's going, so it's set from here. It's a plain value, so that's fine. Through
    /// Unity's own setter, not the hook's copy of it, which Wraith may have taken out already. If the
    /// hook's still in, ours is 1 by then, so it passes the game's straight through.
    pub fn stop(self: *Speed) void {
        if (self.set_hook == null) return;
        self.putBack();
        self.destroyHooks();
    }

    /// From Wraith on any thread, as the lease on the game's speed comes or goes. Without it, the
    /// game's own time scale goes back and its hooks come out, so another plugin's is the only one.
    fn leaseChanged(self: *Speed, held: bool) void {
        if (held) {
            // The game may have set it while we weren't looking
            self.game.store(unknown, .release);
            if (self.set_hook) |h| h.enable() catch |err| log.warn("Can't hook Unity's time scale again: {t}", .{err});
            if (self.get_hook) |h| h.enable() catch {};
            self.dirty.store(true, .release);
            return;
        }
        self.putBack();
        if (self.set_hook) |h| h.disable() catch {};
        if (self.get_hook) |h| h.disable() catch {};
    }

    /// The game's own time scale, through Unity's setter. A plain value, so any thread.
    fn putBack(self: *Speed) void {
        const was = self.ourSpeed();
        self.ours.store(@bitCast(@as(f64, 1)), .release);
        self.dirty.store(false, .release);
        const g = self.game.load(.acquire);
        if (g != unknown and was != 1) {
            const set: *const SetScale = @ptrFromInt(self.set_at);
            set(@bitCast(g));
        }
    }

    fn destroyHooks(self: *Speed) void {
        if (self.set_hook) |h| h.destroy();
        if (self.get_hook) |h| h.destroy();
        self.set_hook = null;
        self.get_hook = null;
    }

    /// From Wraith, any thread. The main thread puts it on.
    fn changed(self: *Speed, speed: f64) bool {
        self.ours.store(@bitCast(speed), .release);
        self.dirty.store(true, .release);
        return true;
    }

    fn ourSpeed(self: *const Speed) f64 {
        return @bitCast(self.ours.load(.acquire));
    }

    /// Main thread, once a frame.
    pub fn apply(self: *Speed) void {
        const set = self.set_hook orelse return;
        const get = self.get_hook orelse return;
        // Before we've set it, what's there is the game's
        if (self.game.load(.acquire) == unknown) self.game.store(@bitCast(get.original()()), .release);
        if (!self.dirty.swap(false, .acq_rel)) return;
        set.original()(scaled(@bitCast(self.game.load(.acquire)), self.ourSpeed()));
    }

    /// The game setting it, on the main thread.
    fn onSet(self: *Speed, hook: sdk.hooks.FnHook(SetScale), value: f32) void {
        self.game.store(@bitCast(value), .release);
        hook.original()(scaled(value, self.ourSpeed()));
    }

    /// The game reading it gets its own.
    fn onGet(self: *Speed, hook: sdk.hooks.FnHook(GetScale)) f32 {
        const g = self.game.load(.acquire);
        return if (g == unknown) hook.original()() else @bitCast(g);
    }
};

fn scaled(game: f32, ours: f64) f32 {
    if (std.math.isNan(game)) return game;
    return @floatCast(std.math.clamp(@as(f64, game) * ours, 0, max_scale));
}

test "ours goes on top of the game's, within what Unity takes" {
    const testing = std.testing;
    try testing.expectEqual(2, scaled(1, 2));
    // The game's own pause stays a pause
    try testing.expectEqual(0, scaled(0, 3));
    // And ours pauses whatever the game's at
    try testing.expectEqual(0, scaled(0.5, 0));
    try testing.expectEqual(max_scale, scaled(4, 50));
}
