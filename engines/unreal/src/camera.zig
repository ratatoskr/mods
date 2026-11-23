//! Hands the player's camera to Wraith's free camera through a camera modifier of our own. The camera
//! manager runs its modifiers last thing each frame, after the game's own camera code, cutscene
//! cameras included, and each one's `BlueprintModifyCamera` goes through `ProcessEvent` with the
//! camera as it is and room for a new one. So ours sees the game's camera and, while the free
//! camera has it, gives back its own instead.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const schema = @import("schema");

const Unreal = @import("ue/Unreal.zig");
const World = @import("ue/World.zig");
const Loop = @import("loop.zig").Loop;

const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;
const Mat4 = sdk.math.Mat4;

const log = sdk.log.scoped(.unreal);

/// Unreal's units are centimetres.
const metre = 100;
const near = 10;
const far = 1_000_000;

pub const Pose = struct {
    position: Vec3,
    rotation: Quat,
    /// Horizontal, in degrees, as Unreal has it.
    fov: f32,
};

pub const Offsets = struct {
    /// `PlayerController.PlayerCameraManager`.
    manager: usize,
    /// `CameraModifier`, the plain kind ours is.
    modifier_class: usize,
    /// `PlayerCameraManager.AddNewCameraModifier` and its `ModifierClass` and `ReturnValue`.
    add: usize,
    add_size: usize,
    add_class: usize,
    add_returns: usize,
    /// `PlayerCameraManager.RemoveCameraModifier` and its `ModifierToRemove`, for going.
    remove: ?usize = null,
    remove_size: usize = 0,
    remove_param: usize = 0,
    /// `CameraModifier.BlueprintModifyCamera` and its params, the camera as it is then the new one.
    modify: usize,
    in_location: usize,
    in_rotation: usize,
    in_fov: usize,
    out_location: usize,
    out_rotation: usize,
    out_fov: usize,
};

pub const Camera = struct {
    world: *const World = undefined,
    loop: *Loop = undefined,
    off: Offsets = undefined,
    /// Wraith's free camera. Null only if Wraith's too old to have one.
    tools: ?W.FreeCamera = null,
    // Game thread only from here down
    /// The camera manager ours is in, and ours.
    manager: usize = 0,
    modifier: usize = 0,
    /// Said so once, since each level load brings a new manager.
    added: bool = false,
    /// The camera as it was last shown, for what's nearest it.
    shown: ?Pose = null,
    /// Runs once the camera's updated, the last thing before the frame's sent to be drawn.
    late: ?Loop.Callback = null,

    pub fn find(ue: *const Unreal, missing: *[]const u8) !Offsets {
        const names = [_][]const u8{ "PlayerController", "PlayerCameraManager", "CameraModifier" };
        var found: [names.len]usize = undefined;
        ue.findIn("/Script/Engine", &names, &found);
        for (names, found) |n, f| if (f == 0) {
            missing.* = n;
            return error.MissingClass;
        };
        const controller, const manager, const modifier = found;
        const add = ue.functionNamed(manager, "AddNewCameraModifier") orelse {
            missing.* = "AddNewCameraModifier";
            return error.MissingFunction;
        };
        const modify = ue.functionNamed(modifier, "BlueprintModifyCamera") orelse {
            missing.* = "BlueprintModifyCamera";
            return error.MissingFunction;
        };
        const off = struct {
            fn off(u: *const Unreal, class: usize, comptime name: []const u8, m: *[]const u8) !usize {
                return u.offsetOf(class, name) orelse {
                    m.* = name;
                    return error.MissingProperty;
                };
            }
        }.off;
        const remove = ue.functionNamed(manager, "RemoveCameraModifier");
        return .{
            .manager = try off(ue, controller, "PlayerCameraManager", missing),
            .modifier_class = modifier,
            .add = add,
            .add_size = @intCast(ue.structSize(add) orelse return error.MissingFunction),
            .add_class = try off(ue, add, "ModifierClass", missing),
            .add_returns = try off(ue, add, "ReturnValue", missing),
            .remove = remove,
            .remove_size = if (remove) |r| @intCast(ue.structSize(r) orelse 0) else 0,
            .remove_param = if (remove) |r| ue.offsetOf(r, "ModifierToRemove") orelse 0 else 0,
            .modify = modify,
            .in_location = try off(ue, modify, "ViewLocation", missing),
            .in_rotation = try off(ue, modify, "ViewRotation", missing),
            .in_fov = try off(ue, modify, "FOV", missing),
            .out_location = try off(ue, modify, "NewViewLocation", missing),
            .out_rotation = try off(ue, modify, "NewViewRotation", missing),
            .out_fov = try off(ue, modify, "NewFOV", missing),
        };
    }

    pub fn start(self: *Camera, world: *const World, loop: *Loop, off: Offsets) void {
        self.world = world;
        self.loop = loop;
        self.off = off;
        self.tools = if (sdk.wraith.root()) |w| w.camera() else null;
        if (self.tools) |t| t.world(.{ .up = .pos_z, .look = .pos_x, .left_handed = true, .metre = metre });
    }

    /// Game thread, once a tick. Each new camera manager, like after a level load, gets ours.
    pub fn tick(self: *Camera) void {
        const mem = self.world.ue.mem;
        const controller = self.world.playerController() orelse return;
        const manager = mem.ptr(controller + self.off.manager) orelse return;
        if (manager == self.manager) return;
        var params: [64]u8 align(16) = @splat(0);
        if (self.off.add_size > params.len) return;
        std.mem.writeInt(usize, params[self.off.add_class..][0..8], self.off.modifier_class, .little);
        self.loop.call(manager, self.off.add, params[0..self.off.add_size]);
        const modifier = std.mem.readInt(usize, params[self.off.add_returns..][0..8], .little);
        self.manager = manager;
        self.modifier = modifier;
        if (modifier == 0) {
            log.warn("The camera manager wouldn't take a camera modifier, so the free camera can't move it", .{});
        } else if (!self.added) {
            log.info("The free camera moves the camera through a camera modifier of ours", .{});
            self.added = true;
        } else log.debug("A new camera manager, so it gets our camera modifier too", .{});
    }

    /// Game thread. Takes ours back out of the camera manager, so a reload doesn't pile them up.
    pub fn leave(self: *Camera) void {
        if (self.modifier == 0 or self.manager == 0) return;
        const remove = self.off.remove orelse return;
        defer self.modifier = 0;
        if (!self.world.ue.objects.isObject(self.manager) or !self.world.ue.objects.isObject(self.modifier)) return;
        var params: [32]u8 align(16) = @splat(0);
        if (self.off.remove_size > params.len) return;
        std.mem.writeInt(usize, params[self.off.remove_param..][0..8], self.modifier, .little);
        self.loop.call(self.manager, remove, params[0..self.off.remove_size]);
    }

    /// Game thread, once a camera modifier's `BlueprintModifyCamera` has run.
    pub fn onModify(raw: *anyopaque, modifier: usize, params: ?*anyopaque) void {
        const self: *Camera = @ptrCast(@alignCast(raw));
        if (modifier != self.modifier or modifier == 0) return;
        const p = params orelse return;
        const io = Io.init(self.world.ue.layout.doubles);
        const shown = if (self.tools) |t| steerWith(t, io, self.off, @intFromPtr(p)) else steerWith(NoTools{}, io, self.off, @intFromPtr(p));
        if (shown) |pose| {
            self.shown = pose;
            publish(self.loop, pose);
        }
        if (self.late) |l| l.func(l.context);
    }

    const NoTools = struct {
        fn camera(_: NoTools, _: *W.CamState) void {}
    };
};

/// `tools` is the free camera, or a stand-in. Gives back the camera as it'll be shown.
fn steerWith(tools: anytype, io: Io, off: Offsets, params: usize) ?Pose {
    const game = io.readPose(params + off.in_location, params + off.in_rotation, params + off.in_fov) orelse return null;
    var state: W.CamState = .{
        .position = game.position,
        .aim = .rotation,
        .target = .{},
        .up = .{ .z = 1 },
        .rotation = game.rotation,
        .roll = 0,
        .fov = std.math.degreesToRadians(game.fov),
    };
    const before = state;
    tools.camera(&state);
    if (std.meta.eql(state, before)) return game;
    const ours: Pose = .{ .position = state.position, .rotation = state.rotation, .fov = std.math.radiansToDegrees(state.fov) };
    io.writePose(params + off.out_location, params + off.out_rotation, params + off.out_fov, ours);
    return ours;
}
/// The view as Wraith wants it, D3D's way round, for drawing over the world.
fn publish(loop: *const Loop, pose: Pose) void {
    const v = viewOf(pose, loop.aspectRatio());
    sdk.frame.setView(v.view, v.projection);
}

fn viewOf(pose: Pose, aspect: f32) struct { view: Mat4, projection: Mat4 } {
    const forward = pose.rotation.rotate(.{ .x = 1 });
    const up = pose.rotation.rotate(.{ .z = 1 });
    const h = std.math.degreesToRadians(std.math.clamp(pose.fov, 1, 170));
    const v = 2 * std.math.atan(@tan(h / 2) / aspect);
    return .{
        .view = .lookAt(pose.position, pose.position.add(forward), up, .left),
        .projection = .perspective(v, aspect, near, far, .left),
    };
}

/// Reads and writes Unreal's vectors and rotators, floats before UE5 and doubles after.
const Io = struct {
    doubles: bool,
    mem: sdk.mem.Memory = .local,

    fn init(doubles: bool) Io {
        return .{ .doubles = doubles };
    }

    fn read3(self: Io, at: usize) ?[3]f32 {
        if (self.doubles) {
            const v = self.mem.load([3]f64, at) catch return null;
            return .{ @floatCast(v[0]), @floatCast(v[1]), @floatCast(v[2]) };
        }
        return self.mem.load([3]f32, at) catch null;
    }

    fn write3(self: Io, at: usize, v: [3]f32) void {
        if (self.doubles) {
            self.mem.store([3]f64, at, .{ v[0], v[1], v[2] }) catch {};
        } else self.mem.store([3]f32, at, v) catch {};
    }

    fn readBool(self: Io, at: usize) bool {
        return (self.mem.load(u8, at) catch 0) != 0;
    }

    fn writeBool(self: Io, at: usize, value: bool) void {
        self.mem.store(u8, at, @intFromBool(value)) catch {};
    }

    fn readPose(self: Io, location: usize, rotation: usize, fov: usize) ?Pose {
        const l = self.read3(location) orelse return null;
        const r = self.read3(rotation) orelse return null;
        const f = self.mem.load(f32, fov) catch return null;
        if (!(f > 0 and f < 180)) return null;
        return .{ .position = .{ .x = l[0], .y = l[1], .z = l[2] }, .rotation = quatOf(r), .fov = f };
    }

    fn writePose(self: Io, location: usize, rotation: usize, fov: usize, pose: Pose) void {
        self.write3(location, .{ pose.position.x, pose.position.y, pose.position.z });
        self.write3(rotation, rotatorOf(pose.rotation));
        self.mem.store(f32, fov, pose.fov) catch {};
    }
};

/// `FRotator`'s pitch, yaw and roll in degrees to a quaternion, the way `FRotator::Quaternion` does.
pub fn quatOf(rotator: [3]f32) Quat {
    const half = std.math.pi / 360.0;
    const sp, const cp = .{ @sin(rotator[0] * half), @cos(rotator[0] * half) };
    const sy, const cy = .{ @sin(rotator[1] * half), @cos(rotator[1] * half) };
    const sr, const cr = .{ @sin(rotator[2] * half), @cos(rotator[2] * half) };
    return .{
        .x = cr * sp * sy - sr * cp * cy,
        .y = -cr * sp * cy - sr * cp * sy,
        .z = cr * cp * sy - sr * sp * cy,
        .w = cr * cp * cy + sr * sp * sy,
    };
}

/// Back to pitch, yaw and roll, the way `FQuat::Rotator` does.
pub fn rotatorOf(q: Quat) [3]f32 {
    const to_deg = 180.0 / std.math.pi;
    const singularity = q.z * q.x - q.w * q.y;
    const yaw = std.math.atan2(2 * (q.w * q.z + q.x * q.y), 1 - 2 * (q.y * q.y + q.z * q.z)) * to_deg;
    const threshold = 0.4999995;
    if (singularity < -threshold) return .{ -90, yaw, normalizeAxis(-yaw - 2 * std.math.atan2(q.x, q.w) * to_deg) };
    if (singularity > threshold) return .{ 90, yaw, normalizeAxis(yaw - 2 * std.math.atan2(q.x, q.w) * to_deg) };
    const pitch = std.math.asin(2 * singularity) * to_deg;
    const roll = std.math.atan2(-2 * (q.w * q.x + q.y * q.z), 1 - 2 * (q.x * q.x + q.y * q.y)) * to_deg;
    return .{ pitch, yaw, roll };
}

fn normalizeAxis(angle: f32) f32 {
    var a = @mod(angle, 360);
    if (a > 180) a -= 360;
    return a;
}

const testing = std.testing;

fn expectVec(want: Vec3, got: Vec3) !void {
    try testing.expectApproxEqAbs(want.x, got.x, 1e-4);
    try testing.expectApproxEqAbs(want.y, got.y, 1e-4);
    try testing.expectApproxEqAbs(want.z, got.z, 1e-4);
}

test "rotators turn the way Unreal's do" {
    // Yaw turns from +x, forward, toward +y, right
    try expectVec(.{ .y = 1 }, quatOf(.{ 0, 90, 0 }).rotate(.{ .x = 1 }));
    // Pitch looks up, toward +z
    try expectVec(.{ .x = @cos(std.math.pi / 6.0), .z = 0.5 }, quatOf(.{ 30, 0, 0 }).rotate(.{ .x = 1 }));
    // And back
    for ([_][3]f32{ .{ 20, -135, 10 }, .{ -45, 60, 0 }, .{ 0, 179, -30 } }) |r| {
        const back = rotatorOf(quatOf(r));
        for (r, back) |a, b| try testing.expectApproxEqAbs(a, b, 1e-3);
    }
}

test "the view looks where the camera does" {
    const pose: Pose = .{ .position = .{ .x = 100 }, .rotation = quatOf(.{ 0, 90, 0 }), .fov = 90 };
    const v = viewOf(pose, 16.0 / 9.0);
    // Ahead of it, which is +y now, is in front, and centred
    const ahead = v.view.transformPoint(.{ .x = 100, .y = 500 });
    try testing.expect(ahead.z > 0);
    try testing.expectApproxEqAbs(0, ahead.x, 1e-3);
    // Its right, +y turned, is -x in the world, and right on screen
    try testing.expect(v.view.transformPoint(.{ .x = 0, .y = 500 }).x > 0);
}

/// A params block laid out like `BlueprintModifyCamera`'s.
const Fake = extern struct {
    delta: f32 = 0.016,
    location: [3]f32 = .{ 1, 2, 3 },
    rotation: [3]f32 = .{ 0, 45, 0 },
    fov: f32 = 80,
    new_location: [3]f32 = .{ 1, 2, 3 },
    new_rotation: [3]f32 = .{ 0, 45, 0 },
    new_fov: f32 = 80,

    const off: Offsets = .{
        .manager = 0,
        .modifier_class = 0,
        .add = 0,
        .add_size = 0,
        .add_class = 0,
        .add_returns = 0,
        .modify = 1,
        .in_location = @offsetOf(Fake, "location"),
        .in_rotation = @offsetOf(Fake, "rotation"),
        .in_fov = @offsetOf(Fake, "fov"),
        .out_location = @offsetOf(Fake, "new_location"),
        .out_rotation = @offsetOf(Fake, "new_rotation"),
        .out_fov = @offsetOf(Fake, "new_fov"),
    };
};

const FakeTools = struct {
    on: bool = false,
    seen: Vec3 = .{},

    pub fn camera(self: *FakeTools, state: *W.CamState) void {
        self.seen = state.position;
        if (!self.on) return;
        state.position = .{ .x = 9 };
        state.fov = std.math.degreesToRadians(100);
    }
};

test "the camera's the free camera's while it has it, and left alone otherwise" {
    var tools: FakeTools = .{};
    var p: Fake = .{};
    const at = @intFromPtr(&p);
    const io = Io.init(false);

    // Off, the free camera sees the game's camera and nothing changes
    const off_pose = steerWith(&tools, io, Fake.off, at).?;
    try testing.expectEqual(1, tools.seen.x);
    try testing.expectEqual(1, off_pose.position.x);
    try testing.expectEqual(1, p.new_location[0]);

    // On, the new camera is ours, with the game's rotation kept
    tools.on = true;
    _ = steerWith(&tools, io, Fake.off, at);
    try testing.expectEqual(9, p.new_location[0]);
    try testing.expectApproxEqAbs(100, p.new_fov, 1e-3);
    try testing.expectApproxEqAbs(45, p.new_rotation[1], 1e-3);
    // And it still sees the game's own each frame
    try testing.expectEqual(1, tools.seen.x);
}
