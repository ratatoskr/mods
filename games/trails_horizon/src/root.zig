const std = @import("std");
const sdk = @import("wraith_sdk");
const Mira = @import("tweaks.zig").Mira;
const Items = @import("tweaks.zig").Items;
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
    camera: Camera = .{},
    posing: Posing = .{},
    speed: Speed = .{},

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        try self.mira_tweaks.start(ctx);
        try self.items_tweaks.start(ctx);
        // The rest still works without them
        self.camera.start() catch |err| log.err("Can't hook the camera, so there's no free camera or view of the game: {t}", .{err});
        self.posing.start() catch |err| log.err("No posing: {t}", .{err});
        self.speed.start(ctx.wraith.game()) catch |err| log.err("Can't find the game's time scale, so Wraith can only speed it up: {t}", .{err});
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}
