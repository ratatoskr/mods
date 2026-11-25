//! Unity games, on Mono or IL2CPP. Drives Wraith's ticks from Unity's main thread, so every
//! plugin's `onTick` can use Unity's engine calls and methods. Wraith's free camera moves the game's main
//! camera, with the built-in render pipeline, URP or HDRP, posing poses its characters, and game
//! speed goes through Unity's time scale. Everything goes through the game's C# runtime and Unity's
//! own engine calls, so it works without knowing anything about the game.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema").Unity;

const Engine = @import("engine.zig").Engine;
const Camera = @import("camera.zig").Camera;
const Render = @import("render.zig").Render;
const Posing = @import("posing.zig").Posing;
const Speed = @import("speed.zig").Speed;
const scene_ = @import("scene.zig");
const Scene = scene_.Scene;
const Explorer = @import("explorer.zig").Explorer;

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.unity);

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    engine: Engine = undefined,
    /// Set once `engine` is, for other threads.
    ready: sdk.atomic.Value(bool) = .init(false),
    /// Taken in `start`, so nobody's ticks run on the render thread first.
    ticks: ?sdk.frame.TickDriver = null,
    camera: Camera = .{},
    render: Render = .{},
    scene: ?Scene = null,
    posing: ?Posing = null,
    speed: Speed = .{},
    /// The Workbench's Scene panel
    explorer: Explorer = .{},

    pub const services = .{unity};

    pub fn unity(self: *Plugin) schema.Unity {
        return .init(self, sdk.salamander.rt.implement(schema.Unity, Service));
    }

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        self.ticks = sdk.frame.driveTicks() catch |err| blk: {
            log.warn("Wraith won't let Unity's main thread tick ({t}), so plugins' ticks stay on the render thread", .{err});
            break :blk null;
        };
        if (self.ticks) |t| if (!t.active()) log.info("Another plugin drives ticks, so Unity's main thread doesn't", .{});
        try ctx.spawn(setUp, .{self});
    }

    pub fn stop(self: *Plugin) void {
        // Waits for its tick and panel, which use the scene
        self.explorer.stop();
        // Puts the game's own time scale back
        self.speed.stop();
        // Before what they use goes
        self.render.stop();
        self.handBack();
        if (self.posing) |*p| p.deinit();
        if (self.scene) |*s| s.deinit();
    }

    /// Ticks go back to the render thread, or the next driver.
    fn handBack(self: *Plugin) void {
        if (self.ticks) |t| t.release();
        self.ticks = null;
    }

    /// Waits for the game to start its C# runtime, which comes after Wraith's loaded plugins.
    fn setUp(self: *Plugin) !void {
        // Nothing would tick otherwise
        errdefer self.handBack();
        const io = self.ctx.io;
        try sdk.frame.toWorker(io);
        const managed = self.ctx.wraith.managed();
        try sdk.tasks.wait(managed.running());
        // Waiting lands back on the render thread, and the rest blocks
        try sdk.frame.toWorker(io);
        var missing: []const u8 = "";
        self.engine = Engine.find(managed, &missing) catch |err| {
            log.err("This Unity's missing {s}, so there's nothing to do", .{missing});
            return err;
        };
        self.scene = Scene.init(&self.engine, managed, &missing) catch |err| blk: {
            log.warn("No finding objects or posing, since this Unity's missing {s}: {t}", .{ missing, err });
            break :blk null;
        };
        self.ready.store(true, .release);
        self.camera.start(&self.engine);
        if (self.scene) |*s| self.posing = Posing.find(&self.engine, s, managed, &missing) catch |err| blk: {
            log.warn("No posing, since this Unity's missing {s}: {t}", .{ missing, err });
            break :blk null;
        };
        self.speed.start(managed, self.ctx.wraith.game()) catch |err| log.info("No time scale to change ({t}), so game speed goes by the clocks", .{err});
        self.render.speed = &self.speed;
        self.render.scene = if (self.scene) |*s| s else null;
        self.render.start(&self.engine, managed, self.ticks, &self.camera, if (self.posing) |*p| p else null) catch |err| {
            log.err("Can't tell when Unity renders: {t}", .{err});
            return err;
        };
        if (self.scene) |*s| self.explorer.start(&self.engine, s, managed, self.camera.tools, self.ticks) catch |err| log.warn("No Scene panel in the Workbench: {t}", .{err});
        log.info("Ready", .{});
        // If neither fires, this Unity renders some other way, which is worth knowing
        try io.sleep(.fromSeconds(10), .awake);
        if (!self.render.seen()) log.warn("Unity hasn't rendered a frame where it was hooked, so there are no frames to hand out", .{});
    }
};

/// Per thread, for what `findObjectsOfType` gives back.
const found_arena = struct {
    threadlocal var arena: ?std.heap.ArenaAllocator = null;

    fn get() std.mem.Allocator {
        if (arena) |*a| {
            _ = a.reset(.retain_capacity);
        } else arena = .init(std.heap.smp_allocator);
        return arena.?.allocator();
    }
};

/// The `Unity` service.
const Service = struct {
    pub fn mainCamera(self: *Plugin) usize {
        if (!self.ready.load(.acquire)) return 0;
        return @intFromPtr(self.engine.main_camera() orelse return 0);
    }

    pub fn findObjectsOfType(self: *Plugin, class_name: []const u8) []const schema.UnityObject {
        if (!self.ready.load(.acquire)) return &.{};
        const s = if (self.scene) |*s| s else return &.{};
        // Good till this thread asks again, which is after salamander's copied it
        const a = found_arena.get();
        var found: std.ArrayList(scene_.Found) = .empty;
        _ = s.objectsOfType(a, class_name, &found) catch return &.{};
        const out = a.alloc(schema.UnityObject, found.items.len) catch return &.{};
        for (found.items, out) |*f, *o| o.* = .{
            .object = @intFromPtr(f.object),
            .native = f.native,
            .transform = @intFromPtr(f.transform),
            .transform_native = f.transform_native,
            .name = f.name.get(),
            .position = f.position,
        };
        return out;
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}

test {
    _ = @import("camera.zig");
    _ = @import("explorer.zig");
    _ = @import("loop.zig");
    _ = @import("posing.zig");
    _ = @import("speed.zig");
    _ = @import("scene.zig");
}
