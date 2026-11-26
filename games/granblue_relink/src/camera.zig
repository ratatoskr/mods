//! The game's camera
const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const schema = @import("schema").GranblueRelink;

const CameraLink = schema.CameraLink;
const RenderCamera = schema.RenderCamera;
const Vec4 = sdk.math.Vec4;
const LookAt = CameraLink.Fns.lookAt;
const LookAtHook = sdk.hooks.FnHook(LookAt);
const State = W.FreeCamera.State;
const clock = @import("clock.zig");
const speed = @import("speed.zig");

/// A camera set again sooner than this is set in the same frame.
const same_frame_ns = 2 * std.time.ns_per_ms;

/// The drawn camera as it was last set.
const Steered = struct {
    link: *CameraLink,
    at: i64,
    view: State,
    moved: bool,
};

pub const Camera = struct {
    tools: ?W.FreeCamera = null,
    look_at: LookAtHook = undefined,
    last: ?Steered = null,
    same_frame: i64 = 0,

    pub fn start(self: *Camera) !void {
        self.tools = if (sdk.wraith.root()) |w| w.camera() else null;
        self.same_frame = clock.ticks(same_frame_ns);

        if (self.tools) |t| t.setWorld(.{ .up = .pos_y, .look = .neg_z, .left_handed = false, .metre = 1 });
        self.look_at = try sdk.hooks.createFnWith(LookAt, try CameraLink.addresses.lookAt(), lookAt, self, .{ .enabled = true });
    }

    fn lookAt(self: *Camera, hook: LookAtHook, link: *CameraLink, eye: ?*Vec4, target: ?*Vec4, up: ?*Vec4, roll: f32, cull: bool, keep_previous: bool) void {
        const camera = link.camera orelse return hook.original()(link, eye, target, up, roll, cull, keep_previous);
        const drawn = drawnCamera();
        const on_screen = drawn != null and camera == drawn.?.camera;
        if (!on_screen) return hook.original()(link, eye, target, up, roll, cull, keep_previous);
        var turned = roll;

        const now = clock.now();
        const again = if (self.last) |l| l.link == link and now - l.at < self.same_frame else false;
        if (again) {
            const l = self.last.?;
            if (l.moved) if (eye) |e| if (target) |at| if (up) |u| put(l.view, camera, e, at, u, &turned);
        } else {
            _ = clock.frame.fetchAdd(1, .monotonic);
            speed.tickIfPaused(now);
            self.last = .{ .link = link, .at = now, .view = undefined, .moved = false };

            if (self.tools) |t| if (eye) |e| if (target) |at| if (up) |u| self.steer(t, camera, drawn.?.index, e, at, u, &turned);
        }
        hook.original()(link, eye, target, up, turned, cull, keep_previous);
        sdk.display.setView(camera.view, camera.proj);
    }

    fn steer(self: *Camera, tools: W.FreeCamera, camera: *RenderCamera, index: u32, eye: *Vec4, target: *Vec4, up: *Vec4, roll: *f32) void {
        var view: State = .{
            .position = eye.xyz(),
            .aim = .target,
            .target = target.xyz(),
            .up = up.xyz(),
            .rotation = .identity,
            .roll = roll.*,
            .fov = camera.fov,
        };
        const before = view;
        tools.camera(index, &view);
        const moved = !std.meta.eql(view, before);
        self.last.?.view = view;
        self.last.?.moved = moved;
        if (moved) put(view, camera, eye, target, up, roll);
    }

    fn put(view: State, camera: *RenderCamera, eye: *Vec4, target: *Vec4, up: *Vec4, roll: *f32) void {
        eye.* = view.position.withW(eye.w);
        target.* = view.target.withW(target.w);
        up.* = view.up.withW(up.w);
        roll.* = view.roll;
        if (view.fov != camera.fov) {
            camera.fov = view.fov;
            camera.projection_dirty = true;
        }
    }
};

const Drawn = struct { camera: *RenderCamera, index: u32 };

/// The renderer's camera the scene's drawn from
fn drawnCamera() ?Drawn {
    const cameras = (RenderCamera.cameras() catch null) orelse return null;
    const count = (RenderCamera.count() catch return null).*;
    const current = (RenderCamera.current() catch return null).*;
    if (current < 0 or current >= count) return null;
    const list: [*]RenderCamera = @ptrCast(cameras);
    return .{ .camera = &list[@intCast(current)], .index = @intCast(current) };
}
