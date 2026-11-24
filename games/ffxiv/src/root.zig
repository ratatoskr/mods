const std = @import("std");
const sdk = @import("wraith_sdk");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.plugin);
const Tick = @import("tick.zig").Tick;

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    tick: Tick = .{},

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        // First, so nobody's ticks run on the render thread before the game's has them
        self.tick.start();
        // FFXIV keeps its cursor free, so Wraith's windows leave it the mouse and keyboard
        ctx.wraith.ui().setMouseFree(true);
        // Changing its speed breaks it online, so it stays off till something turns it on where it
        // works, like Group Pose
        ctx.wraith.game().setSpeedControl(false);
    }

    pub fn stop(self: *Plugin) void {
        self.tick.stop();
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}
