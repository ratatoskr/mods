//! Hands posing each character's skeleton, once Unreal's animated it for the frame. An animated
//! mesh's anim instance gets `BlueprintPostEvaluateAnimation` through `ProcessEvent` each time it's
//! animated, which says which meshes are fresh. But that comes before the component swaps the new
//! bones in from the animation's worker threads, so the posing itself happens once the camera's
//! updated, after every mesh has finished and before the frame's sent to be drawn. Things held in a
//! bone's socket have moved by then, so they don't follow edits. Meshes following another's pose,
//! like clothes, do. The bones are the component's component-space transforms, which aren't
//! reflected, so where they are is found once, from the bone count. Names and parents come from the
//! component's own `GetBoneName` and `GetParentBone`. Edits go straight into the transforms being
//! drawn, which the next animation replaces, so they don't pile up.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const schema = @import("schema");

const Unreal = @import("ue/Unreal.zig");
const FName = Unreal.FName;
const Loop = @import("loop.zig").Loop;
const Camera = @import("camera.zig").Camera;

const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;
const Mat4 = sdk.math.Mat4;
const gpa = std.heap.smp_allocator;
const log = sdk.log.scoped(.unreal);

/// Posing's own limits.
const max_bones = 512;
/// Faces bring big skeletons. Posing gets the first `max_bones` of up to this many.
const max_total = 4096;
const max_actors = 32;
/// Ticks a mesh is remembered after the game last animated it.
const forget_after = 120;

/// A UFunction and where its params are.
const Call = struct {
    function: usize,
    size: usize,
    /// In the order they were asked for.
    params: [2]usize = .{ 0, 0 },
};

pub const Offsets = struct {
    post_evaluate: usize,
    num_bones: Call,
    bone_name: Call,
    parent_bone: Call,
    to_world: Call,
    /// `USkinnedMeshComponent`'s own fields, between its parent's size and its own.
    skinned_from: usize,
    skinned_to: usize,
    /// `SkeletalMeshComponent.AnimScriptInstance`, its main one.
    anim_instance: usize,
};

/// An FTransform, as floats before UE5 and doubles after.
const Layout = struct {
    doubles: bool,

    fn size(self: Layout) usize {
        return if (self.doubles) 0x60 else 0x30;
    }

    fn read(self: Layout, at: usize) Mat4 {
        var v: [12]f32 = undefined;
        if (self.doubles) {
            const d: *align(1) const [12]f64 = @ptrFromInt(at);
            for (&v, d) |*o, x| o.* = @floatCast(x);
        } else v = @as(*align(1) const [12]f32, @ptrFromInt(at)).*;
        return .transform(.{ .x = v[4], .y = v[5], .z = v[6] }, .{ .x = v[0], .y = v[1], .z = v[2], .w = v[3] }, .{ .x = v[8], .y = v[9], .z = v[10] });
    }

    fn write(self: Layout, at: usize, m: Mat4) void {
        const t = m.getTranslation();
        const r = m.rotation();
        const s: Vec3 = .{ .x = m.row(0).xyz().length(), .y = m.row(1).xyz().length(), .z = m.row(2).xyz().length() };
        const v = [12]f32{ r.x, r.y, r.z, r.w, t.x, t.y, t.z, 0, s.x, s.y, s.z, 0 };
        if (self.doubles) {
            const d: *align(1) [12]f64 = @ptrFromInt(at);
            for (d, v) |*o, x| o.* = x;
        } else @as(*align(1) [12]f32, @ptrFromInt(at)).* = v;
    }

    /// A rotation of unit length and a scale that isn't flat, like a real transform.
    fn plausible(self: Layout, mem: anytype, at: usize) bool {
        var buf: [0x60]u8 = undefined;
        if (!mem.bytes(at, buf[0..self.size()])) return false;
        const m = self.read(@intFromPtr(&buf));
        var q: [4]f32 = undefined;
        if (self.doubles) {
            const d = std.mem.bytesAsValue([4]f64, buf[0..32]);
            for (&q, d) |*o, x| o.* = @floatCast(x);
        } else q = std.mem.bytesAsValue([4]f32, buf[0..16]).*;
        const len = @sqrt(q[0] * q[0] + q[1] * q[1] + q[2] * q[2] + q[3] * q[3]);
        if (@abs(len - 1) > 0.01) return false;
        const s = m.row(0).xyz().length();
        return s > 0.001 and s < 1000;
    }
};

/// A mesh the game's animating.
const Mesh = struct {
    seen: u64 = 0,
    /// Animated since it was last posed.
    fresh: bool = false,
    distance: f32 = std.math.inf(f32),
    to_world: Mat4 = .identity,
    /// Not a skinned mesh, or one with no skeleton worth posing.
    skip: bool = false,
    /// All its bones, and how many posing gets, which can be fewer.
    total: u32 = 0,
    count: u32 = 0,
    name: []const u8 = "",
    bones: []W.PosingBone = &.{},
    arena: ?std.heap.ArenaAllocator = null,

    fn deinit(self: *Mesh) void {
        if (self.arena) |*a| a.deinit();
        self.* = .{};
    }
};

/// What a frame works on, off the game thread's stack.
const Scratch = struct {
    matrices: [max_bones]Mat4,
    input: [max_bones]Mat4,
};

/// Where `ComponentSpaceTransformsArray[2]` is in a component, and which of them is drawn.
const Buffers = struct {
    arrays: usize,
    /// `CurrentReadComponentTransforms`, or null for a single buffer.
    read_index: ?usize,
};

/// What follows the bone arrays, watched over frames for the buffer indexes.
const Probe = struct {
    const slots = 116;
    const enough = 30;

    samples: u32 = 0,
    last: [slots]i32 = undefined,
    /// Only ever 0 or 1.
    flag: [slots]bool = @splat(true),
    /// Changed between samples.
    flips: [slots]u32 = @splat(0),
    /// This and the next always differ.
    differs: [slots]bool = @splat(true),

    fn add(p: *Probe, values: [slots]i32) void {
        for (values, 0..) |v, k| {
            if (v != 0 and v != 1) p.flag[k] = false;
            if (p.samples > 0 and v != p.last[k]) p.flips[k] += 1;
            if (k + 1 < slots and v == values[k + 1]) p.differs[k] = false;
        }
        p.last = values;
        p.samples += 1;
    }

    /// The first of the pair, editable then read.
    fn pick(p: *const Probe) ?usize {
        for (0..slots - 1) |k| {
            if (p.flag[k] and p.flag[k + 1] and p.differs[k] and p.flips[k] >= 2) return k;
        }
        return null;
    }
};

pub const Posing = struct {
    service: W.Posing,
    ue: *const Unreal,
    loop: *Loop,
    camera: *const Camera,
    off: Offsets,
    layout: Layout,
    scratch: *Scratch,
    // Game thread only from here down
    meshes: std.AutoHashMapUnmanaged(usize, Mesh) = .empty,
    buffers: ?Buffers = null,
    /// Watching for the buffer indexes, before posing anything.
    probe: ?Probe = null,
    active: bool = false,
    /// The nearest, as of last tick.
    chosen: [max_actors]usize = @splat(0),
    chosen_len: usize = 0,
    /// Null without posing.
    pub fn find(ue: *const Unreal, loop: *Loop, camera: *const Camera, missing: *[]const u8) !?Posing {
        const service = (sdk.wraith.root() orelse return null).posing();
        const names = [_][]const u8{ "AnimInstance", "MeshComponent", "SkinnedMeshComponent", "SceneComponent", "SkeletalMeshComponent" };
        var found: [names.len]usize = undefined;
        ue.findIn("/Script/Engine", &names, &found);
        for (names, found) |n, f| if (f == 0) {
            missing.* = n;
            return error.MissingClass;
        };
        const anim, const mesh, const skinned, const scene, const skeletal = found;
        const call = struct {
            fn call(u: *const Unreal, class: usize, comptime name: []const u8, comptime params: []const []const u8, m: *[]const u8) !Call {
                const f = u.functionNamed(class, name) orelse {
                    m.* = name;
                    return error.MissingFunction;
                };
                var out: Call = .{ .function = f, .size = @intCast(u.structSize(f) orelse return error.MissingFunction) };
                inline for (params, 0..) |p, i| out.params[i] = u.offsetOf(f, p) orelse {
                    m.* = name ++ "'s " ++ p;
                    return error.MissingProperty;
                };
                return out;
            }
        }.call;
        const off: Offsets = .{
            .post_evaluate = ue.functionNamed(anim, "BlueprintPostEvaluateAnimation") orelse {
                missing.* = "BlueprintPostEvaluateAnimation";
                return error.MissingFunction;
            },
            .num_bones = try call(ue, skinned, "GetNumBones", &.{"ReturnValue"}, missing),
            .bone_name = try call(ue, skinned, "GetBoneName", &.{ "BoneIndex", "ReturnValue" }, missing),
            .parent_bone = try call(ue, skinned, "GetParentBone", &.{ "BoneName", "ReturnValue" }, missing),
            .to_world = try call(ue, scene, "K2_GetComponentToWorld", &.{"ReturnValue"}, missing),
            .skinned_from = @intCast(ue.structSize(mesh) orelse return error.MissingClass),
            .skinned_to = @intCast(ue.structSize(skinned) orelse return error.MissingClass),
            .anim_instance = ue.offsetOf(skeletal, "AnimScriptInstance") orelse {
                missing.* = "AnimScriptInstance";
                return error.MissingProperty;
            },
        };
        const scratch = try gpa.create(Scratch);
        return .{
            .service = service,
            .ue = ue,
            .loop = loop,
            .camera = camera,
            .off = off,
            .layout = .{ .doubles = ue.layout.doubles },
            .scratch = scratch,
        };
    }

    pub fn deinit(self: *Posing) void {
        var it = self.meshes.valueIterator();
        while (it.next()) |m| m.deinit();
        self.meshes.deinit(gpa);
        gpa.destroy(self.scratch);
    }

    /// Game thread, once a tick. Picks the nearest of what was animated lately, and forgets the rest.
    pub fn tick(self: *Posing) void {
        self.active = self.service.active();
        const frame = self.loop.frames.load(.acquire);
        var gone: std.ArrayList(usize) = .empty;
        defer gone.deinit(gpa);
        var nearest: [max_actors]struct { mesh: usize, distance: f32 } = undefined;
        var n: usize = 0;
        var it = self.meshes.iterator();
        while (it.next()) |kv| {
            const m = kv.value_ptr;
            if (frame -% m.seen > forget_after) {
                gone.append(gpa, kv.key_ptr.*) catch {};
                continue;
            }
            if (m.skip) continue;
            // Keeps the nearest few, sorted
            var i = n;
            while (i > 0 and nearest[i - 1].distance > m.distance) : (i -= 1) {
                if (i < max_actors) nearest[i] = nearest[i - 1];
            }
            if (i < max_actors) {
                nearest[i] = .{ .mesh = kv.key_ptr.*, .distance = m.distance };
                n = @min(n + 1, max_actors);
            }
        }
        for (gone.items) |k| if (self.meshes.fetchRemove(k)) |kv| {
            var m = kv.value;
            m.deinit();
        };
        for (nearest[0..n], 0..) |c, i| self.chosen[i] = c.mesh;
        self.chosen_len = n;
    }

    /// Game thread, once an anim instance's `BlueprintPostEvaluateAnimation` has run. Notes the
    /// mesh's been animated, and where it is.
    pub fn onPostEvaluate(raw: *anyopaque, anim_instance: usize, _: ?*anyopaque) void {
        const self: *Posing = @ptrCast(@alignCast(raw));
        if (!self.active) return;
        const component = self.ue.outerOf(anim_instance) orelse return;
        const entry = self.meshes.getOrPut(gpa, component) catch return;
        if (!entry.found_existing) {
            entry.value_ptr.* = .{ .skip = !self.ue.isA(component, "SkeletalMeshComponent") };
        }
        const mesh = entry.value_ptr;
        if (mesh.skip) return;
        // Linked and post-process anim instances get this too, but the main one's once a frame
        if (self.ue.mem.ptr(component + self.off.anim_instance) != anim_instance) return;
        mesh.seen = self.loop.frames.load(.acquire);
        mesh.fresh = true;
        mesh.to_world = self.toWorld(component) orelse return;
        if (self.camera.shown) |c| mesh.distance = mesh.to_world.getTranslation().distance(c.position);
    }

    pub fn lateCallback(raw: *anyopaque) void {
        late(@ptrCast(@alignCast(raw)));
    }

    /// Game thread, once the camera's updated, when every mesh has its new bones in and none have
    /// been sent to be drawn. Only fresh ones, so edits don't go on top of last frame's.
    pub fn late(self: *Posing) void {
        if (!self.active) return;
        if (self.buffers == null or self.probe != null) return self.findDrawn();
        for (self.chosen[0..self.chosen_len]) |component| {
            const mesh = self.meshes.getPtr(component) orelse continue;
            if (!mesh.fresh or mesh.skip) continue;
            mesh.fresh = false;
            self.pose(component, mesh);
        }
    }

    fn pose(self: *Posing, component: usize, mesh: *Mesh) void {
        const bones = self.drawn(component) orelse return;
        if (bones.count != mesh.total) {
            self.build(component, mesh) catch {
                mesh.skip = true;
                return;
            };
            if (bones.count != mesh.total) return;
        }
        // Parents come before children, so the first ones are a whole skeleton
        const n = mesh.count;
        const stride = self.layout.size();
        const s = self.scratch;
        for (0..n) |i| s.matrices[i] = self.layout.read(bones.data + i * stride);
        @memcpy(s.input[0..n], s.matrices[0..n]);
        self.service.pose(.{ .id = component, .name = mesh.name, .bones = mesh.bones, .to_world = mesh.to_world }, &s.matrices[0]);
        for (0..n) |i| {
            if (s.matrices[i].approxEql(s.input[i], 1e-6)) continue;
            self.layout.write(bones.data + i * stride, s.matrices[i]);
        }
    }

    const Bones = struct { data: usize, other: ?usize = null, count: u32 };

    /// The bones the component will be drawn with, read afresh each time, since it swaps whole
    /// arrays with the animation's.
    fn drawn(self: *Posing, component: usize) ?Bones {
        const mem = self.ue.mem;
        const b = self.buffers orelse return null;
        const which: usize = if (b.read_index) |r| (if (mem.read(i32, component + r) == 1) 1 else 0) else 0;
        const header = mem.read([2]usize, component + b.arrays + which * 16) orelse return null;
        const count: u32 = @truncate(@as(u64, header[1]));
        if (header[0] == 0 or count == 0 or count > max_total) return null;
        return .{ .data = header[0], .count = count };
    }

    /// Finds the bone arrays on the nearest animated mesh, then watches what follows them for a
    /// few frames, for the two buffer indexes: always one 0 and one 1, swapping as it's animated.
    /// Where they are moves between versions, and other fields nearby hold 0s and 1s that don't.
    fn findDrawn(self: *Posing) void {
        if (self.chosen_len == 0) return;
        const component = self.chosen[0];
        const mesh = self.meshes.getPtr(component) orelse return;
        if (!mesh.fresh or mesh.skip) return;
        mesh.fresh = false;
        if (self.buffers == null) {
            const n = self.numBones(component) orelse return;
            self.buffers = self.findBuffers(component, n) orelse {
                mesh.skip = true;
                return;
            };
            self.probe = .{};
            return;
        }
        const b = &self.buffers.?;
        const p = &self.probe.?;
        const values = self.ue.mem.read([Probe.slots]i32, component + b.arrays + 32) orelse return;
        p.add(values);
        if (p.samples < Probe.enough) return;
        if (p.pick()) |k| {
            b.read_index = b.arrays + 32 + (k + 1) * 4;
            log.info("Posing reads bones at +0x{x} in skinned meshes, drawn as +0x{x} says", .{ b.arrays, b.read_index.? });
        } else log.info("Posing reads bones at +0x{x} in skinned meshes, a single buffer", .{b.arrays});
        self.probe = null;
    }
    /// Two `TArray<FTransform>`s of the bone count, or the second empty.
    fn findBuffers(self: *Posing, component: usize, n: u32) ?Buffers {
        const mem = self.ue.mem;
        var o = std.mem.alignForward(usize, self.off.skinned_from, 8);
        while (o + 64 <= self.off.skinned_to) : (o += 8) {
            const a = mem.read([2]usize, component + o) orelse continue;
            if (!countIs(a[1], n, false)) continue;
            const b = mem.read([2]usize, component + o + 16) orelse continue;
            if (!countIs(b[1], n, true)) continue;
            if (!self.layout.plausible(mem, a[0])) continue;
            return .{ .arrays = o, .read_index = null };
        }
        log.warn("Can't find where skinned meshes keep their bones, so there's no posing", .{});
        return null;
    }
    fn countIs(word: usize, n: u32, or_empty: bool) bool {
        const w: u64 = word;
        const num: u32 = @truncate(w);
        const max: u32 = @truncate(w >> 32);
        if (or_empty and num == 0) return true;
        return num == n and max >= n;
    }

    fn numBones(self: *Posing, component: usize) ?u32 {
        var p: [32]u8 align(16) = @splat(0);
        const c = self.off.num_bones;
        if (c.size > p.len) return null;
        self.loop.call(component, c.function, p[0..c.size]);
        const n = std.mem.readInt(i32, p[c.params[0]..][0..4], .little);
        return if (n > 0 and n <= max_total) @intCast(n) else null;
    }

    fn toWorld(self: *Posing, component: usize) ?Mat4 {
        var p: [0x80]u8 align(16) = @splat(0);
        const c = self.off.to_world;
        if (c.size > p.len) return null;
        self.loop.call(component, c.function, p[0..c.size]);
        return self.layout.read(@intFromPtr(&p) + c.params[0]);
    }

    /// Bone names and parents, from the component, and what it's called after its actor.
    fn build(self: *Posing, component: usize, mesh: *Mesh) !void {
        mesh.deinit();
        mesh.arena = .init(gpa);
        const a = mesh.arena.?.allocator();
        const total = self.numBones(component) orelse return error.NoBones;
        if (total < 3) return error.NoBones;
        const n = @min(total, max_bones);
        const fnames = try a.alloc(FName, n);
        const bones = try a.alloc(W.PosingBone, n);
        var buf: [256]u8 = undefined;
        for (0..n) |i| {
            fnames[i] = self.boneName(component, @intCast(i));
            const text = self.ue.names.text(fnames[i].index, &buf) orelse "?";
            const parent_name = self.parentBone(component, fnames[i]);
            const parent: i32 = for (fnames[0..i], 0..) |f, j| {
                if (f.index == parent_name.index and f.number == parent_name.number) break @intCast(j);
            } else -1;
            bones[i] = .{ .name = try a.dupe(u8, text), .parent = parent };
        }
        const owner = self.ue.outerOf(component) orelse component;
        const name = self.ue.nameOf(owner, &buf) orelse "?";
        mesh.name = try a.dupe(u8, name);
        mesh.bones = bones;
        mesh.total = total;
        mesh.count = n;
    }

    fn boneName(self: *Posing, component: usize, index: i32) FName {
        var p: [32]u8 align(16) = @splat(0);
        const c = self.off.bone_name;
        if (c.size > p.len) return .{ .index = 0, .number = 0 };
        std.mem.writeInt(i32, p[c.params[0]..][0..4], index, .little);
        self.loop.call(component, c.function, p[0..c.size]);
        return std.mem.bytesToValue(FName, p[c.params[1]..][0..8]);
    }

    fn parentBone(self: *Posing, component: usize, name: FName) FName {
        var p: [32]u8 align(16) = @splat(0);
        const c = self.off.parent_bone;
        if (c.size > p.len) return .{ .index = 0, .number = 0 };
        @memcpy(p[c.params[0]..][0..8], std.mem.asBytes(&name));
        self.loop.call(component, c.function, p[0..c.size]);
        return std.mem.bytesToValue(FName, p[c.params[1]..][0..8]);
    }
};

const testing = std.testing;

test "transforms both ways, as floats and doubles" {
    const m: Mat4 = .transform(.{ .x = 1, .y = 2, .z = 3 }, Quat.fromAxisAngle(.{ .z = 1 }, 0.5), .{ .x = 1, .y = 1, .z = 2 });
    inline for (.{ false, true }) |doubles| {
        const layout: Layout = .{ .doubles = doubles };
        var buf: [0x60]u8 align(16) = @splat(0);
        layout.write(@intFromPtr(&buf), m);
        try testing.expect(layout.read(@intFromPtr(&buf)).approxEql(m, 1e-5));
    }
}

test "the buffer indexes are the pair that swaps" {
    var p: Probe = .{};
    for (0..Probe.enough) |f| {
        var v: [Probe.slots]i32 = @splat(0);
        // A pair that's 1 and 0 but never swaps, then the real one, then a field that isn't a flag
        v[2] = 1;
        v[10] = @intCast(f % 2);
        v[11] = @intCast(1 - f % 2);
        v[12] = 248;
        p.add(v);
    }
    try testing.expectEqual(10, p.pick().?);
}

test "bone counts in a TArray's header" {
    try testing.expect(Posing.countIs((@as(usize, 70) << 32) | 70, 70, false));
    try testing.expect(!Posing.countIs((@as(usize, 69) << 32) | 70, 70, false));
    try testing.expect(Posing.countIs(0, 70, true));
    try testing.expect(!Posing.countIs(0, 70, false));
}
