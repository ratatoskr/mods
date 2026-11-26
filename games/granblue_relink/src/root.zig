const std = @import("std");
const sdk = @import("wraith_sdk");
const Camera = @import("camera.zig").Camera;
const Posing = @import("posing.zig").Posing;
const Speed = @import("speed.zig").Speed;

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.granblue_relink);

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    camera: Camera = .{},
    posing: Posing = .{},
    speed: Speed = .{},

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        self.speed.ticks = sdk.threads.driveTicks() catch |err| blk: {
            log.warn("Wraith won't let the game's thread tick ({t}), so plugins' ticks stay on the render thread", .{err});
            break :blk null;
        };
        self.camera.start() catch |err| log.err("Can't hook the camera, so there's no free camera or view of the game: {t}", .{err});
        self.posing.start() catch |err| log.err("No posing: {t}", .{err});
        self.speed.start(ctx.wraith.game()) catch |err| {
            log.err("Can't find the game's slow rate manager, so Wraith can only speed it up: {t}", .{err});
            if (self.speed.ticks) |t| t.release();
            self.speed.ticks = null;
        };
    }

    pub fn stop(self: *Plugin) void {
        if (self.speed.ticks) |t| t.release();
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}
