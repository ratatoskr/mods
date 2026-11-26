const std = @import("std");
const sdk = @import("wraith_sdk");
const Mira = @import("tweaks/money.zig").Mira;
const Items = @import("tweaks/items.zig").Items;
const Gains = @import("tweaks/gains.zig").Gains;
const Battle = @import("tweaks/battle.zig").Battle;
const Field = @import("tweaks/field.zig").Field;
const Party = @import("tweaks/party.zig").Party;
const minigames = @import("tweaks/minigames.zig");
const Camera = @import("camera.zig").Camera;
const Posing = @import("posing.zig").Posing;
const Speed = @import("speed.zig").Speed;

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.trails_horizon);

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    mira_tweaks: Mira = .{},
    items_tweaks: Items = .{},
    gains: Gains = .{},
    battle: Battle = .{},
    field: Field = .{},
    party: Party = .{},
    camera: Camera = .{},
    posing: Posing = .{},
    speed: Speed = .{},
    /// The parts of the game it handles, see `sdk.Lease`. A game's own plugin can hold them instead,
    /// and then what this does for them doesn't count.
    camera_lease: ?sdk.Lease = null,
    posing_lease: ?sdk.Lease = null,
    view_lease: ?sdk.Lease = null,

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        // Taken first, so nobody's ticks run on the render thread before the game's update has them
        self.speed.ticks = sdk.threads.claimTicks(.none) catch |err| blk: {
            log.warn("Wraith won't let the game's thread tick ({t}), so plugins' ticks stay on the render thread", .{err});
            break :blk null;
        };
        try self.mira_tweaks.start(ctx);
        // The rest still works without them
        self.items_tweaks.start(ctx) catch |err| log.err("No item tweaks: {t}", .{err});
        self.gains.start(ctx) catch |err| log.err("No experience or gourmet tweaks: {t}", .{err});
        self.battle.start(ctx) catch |err| log.err("No battle tweaks: {t}", .{err});
        self.field.start(ctx) catch |err| log.err("No field tweaks: {t}", .{err});
        minigames.start(ctx) catch |err| log.err("No minigame tweaks: {t}", .{err});
        self.camera_lease = sdk.Lease.claimCamera(.none) catch null;
        self.posing_lease = sdk.Lease.claimPosing(.none) catch null;
        self.view_lease = sdk.display.claimView(.none) catch null;
        self.camera.start() catch |err| log.err("Can't hook the camera, so there's no free camera or view of the game: {t}", .{err});
        self.posing.start() catch |err| log.err("No posing: {t}", .{err});
        self.speed.start(ctx.wraith.game()) catch |err| log.err("Can't find the game's time scale, so Wraith can only speed it up: {t}", .{err});
        // Party changes need the game's thread
        if (self.speed.ticks != null) self.party.start(ctx) catch |err| log.err("No Party window: {t}", .{err});
    }

    pub fn stop(self: *Plugin) void {
        self.party.stop();
        // Its `tick` does nothing once it's let go, so the game's update can still call it
        if (self.speed.ticks) |t| t.release();
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}
