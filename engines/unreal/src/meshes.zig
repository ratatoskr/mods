//! Every skeletal mesh the game's animating, where it is, and which are nearest the camera. An
//! animated mesh's main anim instance gets `BlueprintPostEvaluateAnimation` through `ProcessEvent`
//! each time it's animated, so that's where meshes are noted, and where others, like posing, hear
//! about them. Also learns where meshes keep their bones as drawn, from the nearest.

const std = @import("std");
const sdk = @import("wraith_sdk");

const Unreal = @import("ue/Unreal.zig");
const Bones = @import("ue/Bones.zig").Bones;
const Loop = @import("loop.zig").Loop;
const Camera = @import("camera.zig").Camera;

const Mat4 = sdk.math.Mat4;
const gpa = std.heap.smp_allocator;

pub const max_nearest = 32;
/// Frames the game animated anything in, after a mesh was last animated, before it's forgotten. A
/// paused world animates nothing, so its meshes stay.
const forget_after = 120;
/// Frames between finding where a mesh is, unless something wants it every frame.
const locate_every = 30;

pub const Mesh = struct {
    seen: u64 = 0,
    /// Not a skeletal mesh.
    skip: bool = false,
    /// When it was last found, and where.
    located: ?u64 = null,
    to_world: Mat4 = .identity,
    distance: f32 = std.math.inf(f32),
};

pub const Offsets = struct {
    post_evaluate: usize,
    /// `SkeletalMeshComponent.AnimScriptInstance`, its main one.
    anim_instance: usize,
    num_bones: Unreal.Call,
    to_world: Unreal.Call,
};

/// Told about each mesh as it's animated, on the game thread.
pub const Listener = struct {
    context: *anyopaque,
    func: *const fn (*anyopaque, component: usize) void,
};

pub const Meshes = struct {
    ue: *const Unreal,
    loop: *Loop,
    camera: *const Camera,
    off: Offsets,
    bones: Bones,
    // Game thread only from here down
    map: std.AutoHashMapUnmanaged(usize, Mesh) = .empty,
    /// Counts frames the game animated anything in, which is what meshes are aged by.
    frame: u64 = 1,
    any_animated: bool = false,
    nearest_buf: [max_nearest]usize = @splat(0),
    nearest_len: usize = 0,
    /// Where the nearest are every frame, rather than now and then, while something needs it.
    precise: bool = false,
    listener: ?Listener = null,

    pub fn find(ue: *const Unreal, loop: *Loop, camera: *const Camera, missing: *[]const u8) !Meshes {
        const names = [_][]const u8{ "AnimInstance", "MeshComponent", "SkinnedMeshComponent", "SceneComponent", "SkeletalMeshComponent" };
        var found: [names.len]usize = undefined;
        ue.findIn("/Script/Engine", &names, &found);
        for (names, found) |n, f| if (f == 0) {
            missing.* = n;
            return error.MissingClass;
        };
        const anim, const mesh, const skinned, const scene, const skeletal = found;
        return .{
            .ue = ue,
            .loop = loop,
            .camera = camera,
            .off = .{
                .post_evaluate = ue.functionNamed(anim, "BlueprintPostEvaluateAnimation") orelse {
                    missing.* = "BlueprintPostEvaluateAnimation";
                    return error.MissingFunction;
                },
                .anim_instance = ue.offsetOf(skeletal, "AnimScriptInstance") orelse {
                    missing.* = "AnimScriptInstance";
                    return error.MissingProperty;
                },
                .num_bones = try ue.callOf(skinned, "GetNumBones", &.{"ReturnValue"}, missing),
                .to_world = try ue.callOf(scene, "K2_GetComponentToWorld", &.{"ReturnValue"}, missing),
            },
            .bones = .{
                .ue = ue,
                .layout = .{ .doubles = ue.layout.doubles },
                .from = @intCast(ue.structSize(mesh) orelse return error.MissingClass),
                .to = @intCast(ue.structSize(skinned) orelse return error.MissingClass),
            },
        };
    }

    pub fn deinit(self: *Meshes) void {
        self.map.deinit(gpa);
    }

    pub fn nearest(self: *const Meshes) []const usize {
        return self.nearest_buf[0..self.nearest_len];
    }

    pub fn get(self: *const Meshes, component: usize) ?*const Mesh {
        return self.map.getPtr(component);
    }

    pub fn isNearest(self: *const Meshes, component: usize) bool {
        return std.mem.indexOfScalar(usize, self.nearest(), component) != null;
    }

    /// Game thread, at an anim instance's post-evaluate.
    pub fn onPostEvaluate(raw: *anyopaque, anim_instance: usize, _: ?*anyopaque) void {
        const self: *Meshes = @ptrCast(@alignCast(raw));
        // The engine's animating it right now, so plain reads are fine
        const mem = self.ue.mem;
        const component = mem.live(usize, anim_instance + Unreal.object.outer);
        if (component == 0) return;
        const entry = self.map.getOrPut(gpa, component) catch return;
        if (!entry.found_existing) entry.value_ptr.* = .{ .skip = !self.ue.isA(component, "SkeletalMeshComponent") };
        const mesh = entry.value_ptr;
        if (mesh.skip) return;
        // Linked and post-process anim instances get this too, but the main one's once a frame
        if (mem.live(usize, component + self.off.anim_instance) != anim_instance) return;
        mesh.seen = self.frame;
        self.any_animated = true;
        if (mesh.located == null or self.frame - mesh.located.? >= locate_every or (self.precise and self.isNearest(component))) {
            if (self.toWorld(component)) |m| {
                mesh.to_world = m;
                mesh.located = self.frame;
            }
        }
        self.bones.animated(component);
        if (self.listener) |l| l.func(l.context, component);
    }

    /// Game thread, once a tick. Ages meshes, forgets the ones the game's stopped animating, and
    /// picks the nearest.
    pub fn tick(self: *Meshes) void {
        if (self.any_animated) {
            self.frame += 1;
            self.any_animated = false;
        }
        var gone: std.ArrayList(usize) = .empty;
        defer gone.deinit(gpa);
        var best: [max_nearest]struct { mesh: usize, distance: f32 } = undefined;
        var n: usize = 0;
        var it = self.map.iterator();
        while (it.next()) |kv| {
            const m = kv.value_ptr;
            if (self.frame - m.seen > forget_after) {
                gone.append(gpa, kv.key_ptr.*) catch {};
                continue;
            }
            if (m.skip or m.located == null) continue;
            // The camera can move while the world's still
            if (self.camera.shown) |c| m.distance = m.to_world.getTranslation().distance(c.position);
            var i = n;
            while (i > 0 and best[i - 1].distance > m.distance) : (i -= 1) {
                if (i < max_nearest) best[i] = best[i - 1];
            }
            if (i < max_nearest) {
                best[i] = .{ .mesh = kv.key_ptr.*, .distance = m.distance };
                n = @min(n + 1, max_nearest);
            }
        }
        for (gone.items) |k| _ = self.map.remove(k);
        for (best[0..n], 0..) |b, i| self.nearest_buf[i] = b.mesh;
        self.nearest_len = n;
    }

    pub fn lateCallback(raw: *anyopaque) void {
        const self: *Meshes = @ptrCast(@alignCast(raw));
        if (self.bones.ready()) return;
        const near = self.nearest();
        self.bones.learn(near, if (near.len > 0 and self.bones.arrays == null) self.numBones(near[0]) else null);
    }

    pub fn numBones(self: *Meshes, component: usize) ?u32 {
        var p: [32]u8 align(16) = @splat(0);
        const c = self.off.num_bones;
        if (c.size > p.len) return null;
        self.loop.call(component, c.function, p[0..c.size]);
        const n = std.mem.readInt(i32, p[c.params[0]..][0..4], .little);
        return if (n > 0 and n <= @import("ue/Bones.zig").max_total) @intCast(n) else null;
    }

    fn toWorld(self: *Meshes, component: usize) ?Mat4 {
        var p: [0x80]u8 align(16) = @splat(0);
        const c = self.off.to_world;
        if (c.size > p.len) return null;
        self.loop.call(component, c.function, p[0..c.size]);
        return self.bones.layout.read(@intFromPtr(&p) + c.params[0]);
    }
};
