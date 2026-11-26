//! Just before Unity renders each frame, on its main thread, once the game's own code for the frame
//! has run, Cinemachine included. That's the player loop's `PostLateUpdate.FinishFrameRendering`,
//! where every render pipeline renders. Unity before 2019 or so might not say where it is, so then
//! it's each camera's `Camera.FireOnPreCull` or `RenderPipelineManager.BeginCameraRendering`, which
//! some games never call. Either way it ticks Wraith there, so every plugin's `onTick` runs on the
//! main thread, then lets the free camera move the main camera. Posing goes a bit earlier, before
//! skinned meshes follow their bones.

const std = @import("std");
const sdk = @import("wraith_sdk");

const Engine = @import("engine.zig").Engine;
const Object = @import("engine.zig").Object;
const Camera = @import("camera.zig").Camera;
const camera_ = @import("camera.zig");
const Photo = @import("photo.zig").Photo;
const Posing = @import("posing.zig").Posing;
const Speed = @import("speed.zig").Speed;
const Scene = @import("scene.zig").Scene;
const loop = @import("loop.zig");

const W = sdk.api.wraith;
const log = sdk.log.scoped(.unity);

/// A player loop step's native function
const Step = fn () callconv(.c) void;
const StepHook = sdk.hooks.FnHook(Step);

/// Where it renders, and where posing goes: after animation, the game's LateUpdates and Timeline,
/// before skinned meshes follow their bones. Newest Unity first.
const render_step = "PostLateUpdate/FinishFrameRendering";
const pose_steps = [_][]const u8{ "PostLateUpdate/UpdateAllRenderers", "PostLateUpdate/UpdateAllSkinnedMeshes" };
/// `static void FireOnPreCull(Camera)`, with IL2CPP's method info after
const PreCull = fn (?*Object, ?*anyopaque) callconv(.c) void;
/// `static void BeginCameraRendering(ScriptableRenderContext, Camera)`. The context is one pointer.
const BeginCamera = fn (usize, ?*Object, ?*anyopaque) callconv(.c) void;

pub const Render = struct {
    engine: *const Engine = undefined,
    /// Wraith's ticks, which Unity's main thread drives. Null if Wraith wouldn't hand them over.
    ticks: ?sdk.Lease = null,
    camera: *Camera = undefined,
    posing: ?*Posing = null,
    /// Photo mode's lens, look and clean shot, after the camera's picked
    photo: ?*Photo = null,
    /// Put on at the start of each frame
    speed: ?*Speed = null,
    /// Looks round a little each frame
    scene: ?*Scene = null,
    step: ?StepHook = null,
    /// Null when posing goes with the rest, at the render step
    pose_step: ?StepHook = null,
    step_seen: sdk.atomic.Value(bool) = .init(false),
    pre_cull: ?sdk.hooks.FnHook(PreCull) = null,
    begin_camera: ?sdk.hooks.FnHook(BeginCamera) = null,
    /// Which have fired, for the log
    pre_cull_seen: sdk.atomic.Value(bool) = .init(false),
    begin_camera_seen: sdk.atomic.Value(bool) = .init(false),
    /// Main thread. Unity's frame count it last ticked for.
    last_frame: i32 = -1,
    /// Main thread. Unity's frame count the camera to steer was last picked for.
    picked_frame: i32 = -1,

    /// Blocks while the game's runtime looks, so not on the render thread.
    pub fn start(self: *Render, engine: *const Engine, managed: W.Managed, ticks: ?sdk.Lease, camera: *Camera, posing: ?*Posing) !void {
        self.engine = engine;
        self.ticks = ticks;
        self.camera = camera;
        self.posing = posing;
        if (self.hookSteps(managed)) return else |err| log.info("No player loop to hook ({t}), so it's each camera's render callbacks", .{err});
        if (posing != null) log.warn("Posing needs Unity's player loop, so there's none", .{});
        self.posing = null;
        if (managed.findMethod("UnityEngine.Camera", "FireOnPreCull", 1)) |at| {
            self.pre_cull = sdk.hooks.createFnWith(PreCull, at, preCull, self, .{ .enabled = true }) catch |err| blk: {
                log.warn("Can't hook Camera.FireOnPreCull: {t}", .{err});
                break :blk null;
            };
        } else |_| {}
        if (managed.findMethod("UnityEngine.Rendering.RenderPipelineManager", "BeginCameraRendering", 2)) |at| {
            self.begin_camera = sdk.hooks.createFnWith(BeginCamera, at, beginCamera, self, .{ .enabled = true }) catch |err| blk: {
                log.warn("Can't hook RenderPipelineManager.BeginCameraRendering: {t}", .{err});
                break :blk null;
            };
        } else |_| {}
        if (self.pre_cull == null and self.begin_camera == null) return error.NowhereToHook;
    }

    /// Puts the code back, waiting for calls in flight.
    pub fn stop(self: *Render) void {
        if (self.step) |h| h.destroy();
        if (self.pose_step) |h| h.destroy();
        if (self.pre_cull) |h| h.destroy();
        if (self.begin_camera) |h| h.destroy();
        self.step = null;
        self.pose_step = null;
        self.pre_cull = null;
        self.begin_camera = null;
    }

    fn hookSteps(self: *Render, managed: W.Managed) !void {
        const found = try loop.find(managed, &(.{render_step} ++ pose_steps));
        self.step = try hookAt(found[0] orelse return error.NoSuchStep, finishFrame, self);
        if (self.posing == null) return;
        for (found[1..], pose_steps) |at, name| {
            const update = at orelse continue;
            self.pose_step = hookAt(update, poseStep, self) catch |err| {
                log.warn("Can't hook {s}: {t}", .{ name, err });
                continue;
            };
            return;
        }
        log.info("Posing goes just before Unity renders, which might be too late for skinned meshes", .{});
    }

    fn hookAt(update: usize, comptime callback: anytype, self: *Render) !StepHook {
        const target = loop.targetOf(update) orelse return error.NotCode;
        const h = switch (target) {
            .slot => |at| try sdk.hooks.createSlot(Step, at, callback, self),
            .code => |at| try sdk.hooks.createFn(Step, at, callback, self),
        };
        errdefer h.destroy();
        try h.enable();
        return h;
    }

    fn poseStep(self: *Render, h: StepHook) void {
        if (self.posing) |p| p.run();
        h.original()();
    }

    fn finishFrame(self: *Render, h: StepHook) void {
        if (!self.step_seen.swap(true, .monotonic)) log.info("Unity's frames come from its player loop", .{});
        if (self.speed) |s| s.apply();
        if (self.scene) |s| s.tick();
        if (self.pose_step == null) if (self.posing) |p| p.run();
        if (self.steering()) |camera| self.rendering(camera);
        h.original()();
    }

    fn preCull(self: *Render, hook: sdk.hooks.FnHook(PreCull), camera: ?*Object, method: ?*anyopaque) void {
        hook.original()(camera, method);
        if (!self.pre_cull_seen.swap(true, .monotonic)) log.info("Unity's frames come from Camera.FireOnPreCull, the built-in pipeline", .{});
        if (self.speed) |s| s.apply();
        self.rendering(camera orelse return);
    }

    fn beginCamera(self: *Render, hook: sdk.hooks.FnHook(BeginCamera), context: usize, camera: ?*Object, method: ?*anyopaque) void {
        hook.original()(context, camera, method);
        if (!self.begin_camera_seen.swap(true, .monotonic)) log.info("Unity's frames come from RenderPipelineManager.BeginCameraRendering, URP or HDRP", .{});
        if (self.speed) |s| s.apply();
        self.rendering(camera orelse return);
    }

    /// Whether either's been called yet.
    pub fn seen(self: *const Render) bool {
        return self.step_seen.load(.monotonic) or self.pre_cull_seen.load(.monotonic) or self.begin_camera_seen.load(.monotonic);
    }

    /// The camera the free camera steers this frame, picked once a frame before any renders, so a
    /// picked camera that's rendering first still gets it.
    fn steering(self: *Render) ?*Object {
        const frame = self.engine.frame_count();
        if (frame != self.picked_frame) {
            self.picked_frame = frame;
            self.camera.pick(self.scene);
            if (self.photo) |p| p.frame();
        }
        return self.camera.target();
    }

    fn rendering(self: *Render, camera: *Object) void {
        const e = self.engine;
        // Not UI cameras, reflections and the like, unless the player's picked one
        if (self.steering() != camera) return;
        // Once a frame, even if the camera renders twice, like for each eye in VR
        const frame = e.frame_count();
        if (frame != self.last_frame) {
            self.last_frame = frame;
            if (self.ticks != null) sdk.threads.tick();
            // The player loop's step ticks it, when there's one
            if (self.step == null) if (self.scene) |s| s.tick();
        }
        self.camera.steer(camera);
        camera_.publishView(e, camera);
    }
};
