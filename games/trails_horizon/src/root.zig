const std = @import("std");
const sdk = @import("wraith_sdk");
const Mira = @import("tweaks.zig").Mira;
const Items = @import("tweaks.zig").Items;

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    mira_tweaks: Mira = .{},
    items_tweaks: Items = .{},

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        try self.mira_tweaks.start(ctx);
        try self.items_tweaks.start(ctx);
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}
