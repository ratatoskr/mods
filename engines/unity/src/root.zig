//! Unity games, on Mono or IL2CPP. Offers Unity's main thread to plugins in any language through
//! the `Unity` service, Camera Tools moves the game's main camera, with the built-in render
//! pipeline, URP or HDRP, and posing poses its characters. Everything goes through the game's C#
//! runtime and Unity's own engine calls, so it works without knowing anything about the game.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");

const Engine = @import("engine.zig").Engine;
const Camera = @import("camera.zig").Camera;
const Render = @import("render.zig").Render;
const Posing = @import("posing.zig").Posing;
const frames_ = @import("frames.zig");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.unity);

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    engine: Engine = undefined,
    /// Set once `engine` is, for other threads.
    ready: sdk.atomic.Value(bool) = .init(false),
    frames: frames_.Frames = .{},
    camera: Camera = .{},
    render: Render = .{},
    posing: ?Posing = null,

    pub const services = .{unity};

    pub fn unity(self: *Plugin) schema.Unity {
        return .init(self, sdk.salamander.rt.implement(schema.Unity, Service));
    }

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        try ctx.spawn(setUp, .{self});
    }

    pub fn stop(self: *Plugin) void {
        // Before what they use goes
        self.render.stop();
        self.frames.deinit();
        if (self.posing) |*p| p.deinit();
    }

    /// Waits for the game to start its C# runtime, which comes after Wraith's loaded plugins.
    fn setUp(self: *Plugin) !void {
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
        self.ready.store(true, .release);
        self.camera.start(&self.engine);
        self.posing = Posing.find(&self.engine, managed, &missing) catch |err| blk: {
            log.warn("No posing, since this Unity's missing {s}: {t}", .{ missing, err });
            break :blk null;
        };
        self.render.start(&self.engine, managed, &self.frames, &self.camera, if (self.posing) |*p| p else null) catch |err| {
            log.err("Can't tell when Unity renders: {t}", .{err});
            return err;
        };
        log.info("Ready", .{});
        // If neither fires, this Unity renders some other way, which is worth knowing
        try io.sleep(.fromSeconds(10), .awake);
        if (!self.render.seen()) log.warn("Unity hasn't rendered a frame where it was hooked, so there are no frames to hand out", .{});
    }
};

/// The `Unity` service.
const Service = struct {
    pub fn onFrame(self: *Plugin, handler: schema.UnityFrame) schema.UnitySubscription {
        const s = self.frames.subscribe(handler) orelse return .{};
        return .init(s, sdk.salamander.rt.implement(schema.UnitySubscription, frames_.Subscriber));
    }

    pub fn mainCamera(self: *Plugin) usize {
        if (!self.ready.load(.acquire)) return 0;
        return @intFromPtr(self.engine.main_camera() orelse return 0);
    }
};

comptime {
    sdk.exportPlugin(Plugin);
}

test {
    _ = @import("camera.zig");
    _ = @import("loop.zig");
    _ = @import("posing.zig");
}
