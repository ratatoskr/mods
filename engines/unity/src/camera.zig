//! Hands the main camera to Camera Tools just before Unity renders it, once the game's own camera
//! code has had its say, Cinemachine included. `Render` calls it on the main thread.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");

const Engine = @import("engine.zig").Engine;
const Object = @import("engine.zig").Object;

const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;
const Mat4 = sdk.math.Mat4;

const Pose = struct {
    position: Vec3,
    rotation: Quat,
    /// Vertical, in degrees, as Unity has it
    fov: f32,
};

pub const Camera = struct {
    engine: *const Engine = undefined,
    /// Null without Camera Tools, which leaves the camera to the game.
    tools: ?schema.CameraTools = null,
    // Main thread only from here down
    /// The game's own camera, as of the last frame it set it.
    game: Pose = undefined,
    /// What we last put on the camera. Null while the game has it.
    wrote: ?Pose = null,

    pub fn start(self: *Camera, engine: *const Engine) void {
        self.engine = engine;
        self.tools = sdk.salamander.service(schema.CameraTools, "camera");
        if (self.tools) |t| t.world(.{ .up = .pos_y, .look = .pos_z, .left_handed = true, .metre = 1 });
    }

    /// Main thread, as the main camera's about to render.
    pub fn steer(self: *Camera, camera: *Object) void {
        self.steerWith(self.tools orelse return, camera);
    }

    /// `tools` is Camera Tools, or a stand-in for tests.
    fn steerWith(self: *Camera, tools: anytype, camera: *Object) void {
        const e = self.engine;
        // Not UI cameras, reflections and the like
        if (e.main_camera() != camera) return;
        const transform = e.transform(camera) orelse return;
        const now = read(e, camera, transform);
        // Whatever's unchanged since we wrote it, the game didn't set, so its own is as it was.
        // Games often set where the camera is every frame but leave its fov alone
        if (self.wrote) |w| {
            if (!std.meta.eql(now.position, w.position)) self.game.position = now.position;
            if (!std.meta.eql(now.rotation, w.rotation)) self.game.rotation = now.rotation;
            if (now.fov != w.fov) self.game.fov = now.fov;
        } else self.game = now;

        var state: schema.CamState = .{
            .position = self.game.position,
            .aim = .rotation,
            .target = .{},
            .up = .{ .y = 1 },
            .rotation = self.game.rotation,
            .roll = 0,
            .fov = std.math.degreesToRadians(self.game.fov),
        };
        const before = state;
        tools.camera(&state);
        if (std.meta.eql(state, before)) {
            // Camera Tools let go. Put the game's back, for games that don't set it every frame
            if (self.wrote != null) write(e, camera, transform, self.game);
            self.wrote = null;
            return;
        }
        write(e, camera, transform, .{ .position = state.position, .rotation = state.rotation, .fov = std.math.radiansToDegrees(state.fov) });
        // Read back, since Unity tidies what it's given, like normalizing the rotation
        self.wrote = read(e, camera, transform);
    }
};

fn read(e: *const Engine, camera: *Object, transform: *Object) Pose {
    var pose: Pose = .{ .position = .{}, .rotation = .identity, .fov = e.get_fov(camera) };
    e.get_position(transform, &pose.position);
    e.get_rotation(transform, &pose.rotation);
    return pose;
}

fn write(e: *const Engine, camera: *Object, transform: *Object, pose: Pose) void {
    e.set_position(transform, &pose.position);
    e.set_rotation(transform, &pose.rotation);
    e.set_fov(camera, pose.fov);
}

/// Main thread, once Camera Tools has had its say, so plugins drawing over the world, like posing
/// and the Scene panel's gizmo, see it the way it's drawn.
pub fn publishView(e: *const Engine, camera: *Object) void {
    var view: Mat4 = .identity;
    var projection: Mat4 = .identity;
    e.world_to_camera(camera, &view);
    e.projection(camera, &projection);
    const d3d = toD3d(view, projection);
    sdk.frame.setView(d3d.view, d3d.projection);
}

/// Unity's view is mirrored, from its left-handed world to an OpenGL camera that looks down -z with
/// depth from -1 to 1. The gizmo works out which half of its rings faces the camera from the view
/// and projection, and gets it backwards for that mix, so it'd draw the back halves while picking the
/// front ones. This gives it D3D's way round, looking down +z with depth from 0 to 1, like most
/// games. The two together still put everything in the same place on screen.
fn toD3d(view: Mat4, projection: Mat4) struct { view: Mat4, projection: Mat4 } {
    const flip: Mat4 = .scaling(.{ .x = 1, .y = 1, .z = -1 });
    // z' = (z + w) / 2
    var depth: Mat4 = .identity;
    depth.m[10] = 0.5;
    depth.m[14] = 0.5;
    return .{ .view = view.mul(flip), .projection = flip.mul(projection).mul(depth) };
}

const testing = std.testing;

/// A camera the game sets, or not, and what's been written to it.
const FakeGame = struct {
    var pose: Pose = .{ .position = .{ .x = 1 }, .rotation = .identity, .fov = 60 };
    var writes: u32 = 0;
    const camera: *Object = @ptrFromInt(0x1000);
    const transform: *Object = @ptrFromInt(0x2000);

    fn mainCamera() callconv(.c) ?*Object {
        return camera;
    }
    fn transformOf(_: *Object) callconv(.c) ?*Object {
        return transform;
    }
    fn getPosition(_: *Object, out: *Vec3) callconv(.c) void {
        out.* = pose.position;
    }
    fn setPosition(_: *Object, in: *const Vec3) callconv(.c) void {
        pose.position = in.*;
        writes += 1;
    }
    fn getRotation(_: *Object, out: *Quat) callconv(.c) void {
        out.* = pose.rotation;
    }
    fn setRotation(_: *Object, in: *const Quat) callconv(.c) void {
        pose.rotation = in.*;
    }
    fn getFov(_: *Object) callconv(.c) f32 {
        return pose.fov;
    }
    fn setFov(_: *Object, fov: f32) callconv(.c) void {
        pose.fov = fov;
    }
    fn frameCount() callconv(.c) i32 {
        return 1;
    }
    fn matrix(_: *Object, out: *Mat4) callconv(.c) void {
        out.* = .identity;
    }

    const engine: Engine = .{
        .main_camera = mainCamera,
        .transform = transformOf,
        .get_position = getPosition,
        .set_position = setPosition,
        .get_rotation = getRotation,
        .set_rotation = setRotation,
        .get_fov = getFov,
        .set_fov = setFov,
        .frame_count = frameCount,
        .world_to_camera = matrix,
        .projection = matrix,
        .local_to_world = matrix,
    };
};

/// Camera Tools: hands back its own camera while it's on.
const FakeTools = struct {
    on: bool = false,
    position: Vec3 = .{ .x = 9 },
    fov: f32 = std.math.degreesToRadians(90),
    /// What the game had, as it came in
    seen: Vec3 = .{},

    pub fn camera(self: *FakeTools, state: *schema.CamState) void {
        self.seen = state.position;
        if (!self.on) return;
        state.position = self.position;
        state.fov = self.fov;
    }
};

test "moves the main camera while Camera Tools has it, and gives the game's back" {
    var cam: Camera = .{ .engine = &FakeGame.engine };
    var tools: FakeTools = .{};
    FakeGame.writes = 0;

    // Off, the game's camera is left alone
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(0, FakeGame.writes);
    try testing.expectEqual(1, tools.seen.x);

    // On, it's Camera Tools', with its fov in degrees
    tools.on = true;
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(9, FakeGame.pose.position.x);
    try testing.expectApproxEqAbs(90, FakeGame.pose.fov, 0.001);

    // A game that sets its camera every frame still shows Camera Tools where it is
    FakeGame.pose.position = .{ .x = 2 };
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(2, tools.seen.x);
    try testing.expectEqual(9, FakeGame.pose.position.x);

    // One that doesn't still has its last own pose, not ours
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(2, tools.seen.x);

    // Let go, the game gets its camera back as it was
    tools.on = false;
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(2, FakeGame.pose.position.x);
    try testing.expectApproxEqAbs(60, FakeGame.pose.fov, 0.001);
    const writes = FakeGame.writes;
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(writes, FakeGame.writes);
}

test "other cameras are left alone" {
    var cam: Camera = .{ .engine = &FakeGame.engine };
    var tools: FakeTools = .{ .on = true };
    FakeGame.writes = 0;
    cam.steerWith(&tools, @ptrFromInt(0x3000));
    try testing.expectEqual(0, FakeGame.writes);
}

test "Unity's camera goes to D3D's way round, landing in the same place" {
    // OpenGL's perspective, row-vector style, as Unity's memory reads
    const n: f32 = 0.5;
    const f: f32 = 100;
    const a = -(f + n) / (f - n);
    const b = -2 * f * n / (f - n);
    const gl: Mat4 = .{ .m = .{ 1.5, 0, 0, 0, 0, 2, 0, 0, 0, 0, a, -1, 0, 0, b, 0 } };
    // Unity's world is left-handed, so its view mirrors z on the way to the camera's
    const view = Mat4.translation(.{ .x = -3 }).mul(.scaling(.{ .x = 1, .y = 1, .z = -1 }));
    const d3d = toD3d(view, gl);

    // No mirror left, and the projection's D3D's way round, which is what the gizmo goes by
    const v = d3d.view;
    const det = v.at(0, 0) * (v.at(1, 1) * v.at(2, 2) - v.at(1, 2) * v.at(2, 1)) -
        v.at(0, 1) * (v.at(1, 0) * v.at(2, 2) - v.at(1, 2) * v.at(2, 0)) +
        v.at(0, 2) * (v.at(1, 0) * v.at(2, 1) - v.at(1, 1) * v.at(2, 0));
    try testing.expect(det > 0);
    try testing.expect(d3d.projection.at(2, 3) > 0);

    // In front of the camera, which is +z in Unity's world
    const p: Vec3 = .{ .x = 4, .y = 1, .z = 5 };
    try testing.expect(d3d.view.transformPoint(p).z > 0);
    // Same spot on screen
    const before = view.mul(gl).transformPoint(p);
    const after = d3d.view.mul(d3d.projection).transformPoint(p);
    try testing.expectApproxEqAbs(before.x, after.x, 1e-5);
    try testing.expectApproxEqAbs(before.y, after.y, 1e-5);
    // Depth from 0 at the near plane to 1 at the far one
    const vp = d3d.view.mul(d3d.projection);
    try testing.expectApproxEqAbs(0, vp.transformPoint(.{ .x = 3, .z = n }).z, 1e-4);
    try testing.expectApproxEqAbs(1, vp.transformPoint(.{ .x = 3, .z = f }).z, 1e-4);
}
