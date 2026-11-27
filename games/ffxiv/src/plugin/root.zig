const std = @import("std");
const sdk = @import("wraith_sdk");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.plugin);
const schema = @import("schema");
const sqpack = @import("sqpack");
const Tick = @import("tick.zig").Tick;
const Explorer = @import("explorer.zig").Explorer;

/// What's in its Workbench tab
const Part = enum { sheets };

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    tick: Tick = .{},
    /// The game's files, once `openPack` has them.
    pack: ?sqpack.Pack = null,
    /// Its Workbench tab, with a part each in `parts`
    tab: ?sdk.workbench.Panel = null,
    parts: sdk.workbench.Parts(Part) = .init(.{ .sheets = "Sheets" }),
    explorer: Explorer = .{},

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        // First, so nobody's ticks run on the render thread before the game's has them
        self.tick.start();
        // FFXIV keeps its cursor free, so Wraith's windows leave it the mouse and keyboard
        ctx.wraith.ui().setMouseFree(true);
        // Changing its speed breaks it online, so it stays off till something turns it on where it
        // works, like Group Pose
        ctx.wraith.game().setSpeedControl(false);
        self.tab = sdk.workbench.addPanel(self, drawTab, .{ .title = "FFXIV", .kind = "ffxiv" }) catch |err| blk: {
            log.warn("No FFXIV tab in the Workbench: {t}", .{err});
            break :blk null;
        };
        try ctx.spawn(askDalamud, .{self});
        try ctx.spawn(openPack, .{self});
    }

    pub fn stop(self: *Plugin) void {
        self.tick.stop();
        // Its parts read the pack, so they go first
        if (self.tab) |t| t.remove();
        self.tab = null;
        self.explorer.stop();
        if (self.pack) |*p| p.close(self.ctx.io, self.ctx.allocator);
        self.pack = null;
    }

    /// From the `game` folder the exe's in. On a worker, as it's files.
    fn openPack(self: *Plugin) !void {
        const io = self.ctx.io;
        try sdk.threads.toWorker(io);
        var path_buf: [1024]u8 = undefined;
        const exe = sdk.Module.main().path(&path_buf) orelse return error.NoExePath;
        const game_dir = std.fs.path.dirname(exe) orelse return error.NoExePath;
        const began = std.Io.Clock.awake.now(io);
        self.pack = sqpack.Pack.open(io, self.ctx.allocator, game_dir) catch |err| {
            log.err("Can't open the game's files in {s} ({t})", .{ game_dir, err });
            return err;
        };
        const took = @divTrunc(began.durationTo(std.Io.Clock.awake.now(io)).nanoseconds, std.time.ns_per_ms);
        var installed: usize = 0;
        for (self.pack.?.repos) |*r| installed += @intFromBool(r.version().len > 0);
        log.info("Opened the game's files, version {s} with {d} expansions ({d}ms)", .{ self.pack.?.repos[0].version(), installed -| 1, took });
        self.explorer.start(&self.pack.?, io);
    }

    /// On the Workbench's thread.
    fn drawTab(self: *Plugin) void {
        self.parts.draw(self, drawPart);
    }

    fn drawPart(self: *Plugin, part: Part) void {
        switch (part) {
            .sheets => self.explorer.draw(),
        }
    }

    /// Dalamud runs its C# on .NET's CoreCLR in the game, which Wraith joins once it's started. Asks
    /// which Dalamud it is, through `schemas/dalamud.sal`, to show calling into it works. Without
    /// Dalamud there's no C#, so this waits for good, which is fine.
    fn askDalamud(self: *Plugin) !void {
        const managed = self.ctx.wraith.managed();
        try sdk.tasks.wait(managed.running());
        if (managed.runtimeKind() != .coreclr) return;
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

test {
    _ = @import("explorer.zig");
}
