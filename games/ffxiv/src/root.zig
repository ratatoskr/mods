const std = @import("std");
const sdk = @import("wraith_sdk");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.plugin);
const schema = @import("schema");
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
        try ctx.spawn(askDalamud, .{self});
    }

    pub fn stop(self: *Plugin) void {
        self.tick.stop();
    }

    /// Dalamud runs its C# on .NET's CoreCLR in the game, which Wraith joins once it's started. Asks
    /// which Dalamud it is, through `schemas/dalamud.sal`, to show calling into it works. Without
    /// Dalamud there's no C#, so this waits for good, which is fine.
    fn askDalamud(self: *Plugin) !void {
        const managed = self.ctx.wraith.managed();
        try sdk.tasks.wait(managed.running());
        if (managed.kind() != .coreclr) return;
        const Versioning = schema.Dalamud.Versioning;
        // Found once the C# is running, so this says if it isn't Dalamud's
        _ = Versioning.addresses.scmVersion() catch |err| {
            log.info("The game runs .NET, but it isn't Dalamud's ({t})", .{err});
            return;
        };
        log.info("Dalamud {s} is running", .{Versioning.scmVersion().get()});
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}
