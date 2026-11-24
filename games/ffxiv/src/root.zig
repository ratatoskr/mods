const std = @import("std");
const sdk = @import("wraith_sdk");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.plugin);

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        // FFXIV keeps its cursor free, so Wraith's windows leave it the mouse and keyboard
        ctx.wraith.ui().setMouseFree(true);
    }

    pub fn stop(self: *Plugin) void {
        _ = self;
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}
