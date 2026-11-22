//! Hands posing each character's skeleton, once Unity's animated it and the game's LateUpdate
//! scripts have run, but before it's skinned and drawn. Characters are the scene's Animators, and a
//! skeleton is the transforms under one. Edits go back as each transform's local position, rotation
//! and scale. Ones the game doesn't set every frame get the game's own back the next frame, so edits
//! don't pile up.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");

const engine_ = @import("engine.zig");
const Engine = engine_.Engine;
const Object = engine_.Object;

const W = sdk.api.wraith;
const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;
const Mat4 = sdk.math.Mat4;
const local = sdk.mem.Memory.local;
const gpa = std.heap.smp_allocator;
const word = @sizeOf(usize);
const array_length = 3 * word;
const array_items = 4 * word;

/// Posing's own limits
const max_bones = 512;
const max_actors = 32;
/// Animators looked at for the nearest, since a scene can have lots
const max_animators = 512;
/// Frames a name's kept after its object was last seen
const name_frames = 600;

/// Unity's engine calls for it, found like `Engine`'s.
const Calls = struct {
    find_objects: *const fn (?*Object, bool) callconv(.c) ?*Object,
    name: *const fn (*Object) callconv(.c) ?*Object,
    child_count: *const fn (*Object) callconv(.c) i32,
    child: *const fn (*Object, i32) callconv(.c) ?*Object,
    get_local_position: *const fn (*Object, *Vec3) callconv(.c) void,
    set_local_position: *const fn (*Object, *const Vec3) callconv(.c) void,
    get_local_rotation: *const fn (*Object, *Quat) callconv(.c) void,
    set_local_rotation: *const fn (*Object, *const Quat) callconv(.c) void,
    get_local_scale: *const fn (*Object, *Vec3) callconv(.c) void,
    set_local_scale: *const fn (*Object, *const Vec3) callconv(.c) void,
    local_to_world: *const fn (*Object, *Mat4) callconv(.c) void,
    world_to_camera: *const fn (*Object, *Mat4) callconv(.c) void,
    projection: *const fn (*Object, *Mat4) callconv(.c) void,

    const names = .{
        .find_objects = .{ "UnityEngine.Object", "FindObjectsOfType" },
        .name = .{ "UnityEngine.Object", "GetName" },
        .child_count = .{ "UnityEngine.Transform", "get_childCount" },
        .child = .{ "UnityEngine.Transform", "GetChild" },
        .get_local_position = .{ "UnityEngine.Transform", "get_localPosition_Injected", "INTERNAL_get_localPosition" },
        .set_local_position = .{ "UnityEngine.Transform", "set_localPosition_Injected", "INTERNAL_set_localPosition" },
        .get_local_rotation = .{ "UnityEngine.Transform", "get_localRotation_Injected", "INTERNAL_get_localRotation" },
        .set_local_rotation = .{ "UnityEngine.Transform", "set_localRotation_Injected", "INTERNAL_set_localRotation" },
        .get_local_scale = .{ "UnityEngine.Transform", "get_localScale_Injected", "INTERNAL_get_localScale" },
        .set_local_scale = .{ "UnityEngine.Transform", "set_localScale_Injected", "INTERNAL_set_localScale" },
        .local_to_world = .{ "UnityEngine.Transform", "get_localToWorldMatrix_Injected", "INTERNAL_get_localToWorldMatrix" },
        .world_to_camera = .{ "UnityEngine.Camera", "get_worldToCameraMatrix_Injected", "INTERNAL_get_worldToCameraMatrix" },
        .projection = .{ "UnityEngine.Camera", "get_projectionMatrix_Injected", "INTERNAL_get_projectionMatrix" },
    };
};

/// A transform's own position, rotation and scale, relative to its parent.
pub const Local = struct {
    position: Vec3,
    rotation: Quat,
    scale: Vec3,

    fn read(c: *const Calls, t: *Object) Local {
        var l: Local = .{ .position = .{}, .rotation = .identity, .scale = .{} };
        c.get_local_position(t, &l.position);
        c.get_local_rotation(t, &l.rotation);
        c.get_local_scale(t, &l.scale);
        return l;
    }

    fn write(l: Local, c: *const Calls, t: *Object) void {
        c.set_local_position(t, &l.position);
        c.set_local_rotation(t, &l.rotation);
        c.set_local_scale(t, &l.scale);
    }

    /// Row-vector style, like Unity's own matrices read as tuft's.
    pub fn matrix(l: Local) Mat4 {
        return .transform(l.position, l.rotation, l.scale);
    }

    /// Back out of a matrix with no shear, which is all posing makes.
    pub fn of(m: Mat4) Local {
        return .{
            .position = m.getTranslation(),
            .rotation = m.rotation(),
            .scale = .{ .x = m.row(0).xyz().length(), .y = m.row(1).xyz().length(), .z = m.row(2).xyz().length() },
        };
    }

    fn near(a: Local, b: Local) bool {
        // q and -q are the same turn
        return a.position.approxEql(b.position, 1e-4) and a.scale.approxEql(b.scale, 1e-5) and
            (a.rotation.approxEql(b.rotation, 1e-5) or a.rotation.approxEql(.{ .x = -b.rotation.x, .y = -b.rotation.y, .z = -b.rotation.z, .w = -b.rotation.w }, 1e-5));
    }
};

/// A transform we've posed: what the game had, and what we put there.
const Track = struct {
    game: Local,
    wrote: Local,
    frame: u32,
};

const Name = struct {
    buf: [64]u8 = undefined,
    len: u8 = 0,
    frame: u32 = 0,

    fn get(n: *const Name) []const u8 {
        return n.buf[0..n.len];
    }
};

/// What a frame works on, kept off Unity's main thread's stack. Not the objects, which go on the
/// stack where the garbage collector sees them.
const Scratch = struct {
    bones: [max_bones]schema.PosingBone,
    ids: [max_bones]usize,
    locals: [max_bones]Local,
    matrices: [max_bones]Mat4,
    input: [max_bones]Mat4,
};

pub const Posing = struct {
    service: schema.Posing,
    calls: Calls,
    engine: *const Engine,
    animator_type: usize,
    /// Where `UnityEngine.Object` keeps its native object, which stays the same while it's around
    cached_ptr: usize,
    scratch: *Scratch,
    // Main thread only from here down
    tracked: std.AutoHashMapUnmanaged(usize, Track) = .empty,
    names: std.AutoHashMapUnmanaged(usize, Name) = .empty,
    frame: u32 = 0,

    /// Null without posing. Blocks while the game's runtime looks, so not on the render thread.
    pub fn find(engine: *const Engine, managed: W.Managed, missing: *[]const u8) !?Posing {
        const service = sdk.salamander.service(schema.Posing, "posing") orelse return null;
        const calls = try engine_.findCalls(Calls, Calls.names, managed, missing);
        const animator_type = try managed.typeObject("UnityEngine.Animator");
        const cached_ptr = try managed.fieldOffset("UnityEngine.Object", "m_CachedPtr");
        return .{
            .service = service,
            .calls = calls,
            .engine = engine,
            .animator_type = animator_type,
            .cached_ptr = cached_ptr,
            .scratch = try gpa.create(Scratch),
        };
    }

    pub fn deinit(self: *Posing) void {
        self.tracked.deinit(gpa);
        self.names.deinit(gpa);
        gpa.destroy(self.scratch);
    }

    /// Main thread, once everything's animated and before it's drawn.
    pub fn run(self: *Posing) void {
        self.frame +%= 1;
        const active = self.service.active();
        if (!active and self.tracked.count() == 0) return;
        if (self.frame % name_frames == 0) self.dropOldNames();

        // Nearest the camera first
        const Near = struct {
            animator: *Object,
            distance: f32,
            fn lessThan(_: void, a: @This(), b: @This()) bool {
                return a.distance < b.distance;
            }
        };
        const c = &self.calls;
        const e = self.engine;
        const array = c.find_objects(@ptrFromInt(self.animator_type), false) orelse return;
        const n = @min(local.load(usize, @intFromPtr(array) + array_length) catch 0, max_animators);
        const items: [*]const ?*Object = @ptrFromInt(@intFromPtr(array) + array_items);
        var eye: Vec3 = .{};
        if (e.main_camera()) |cam| if (e.transform(cam)) |t| e.get_position(t, &eye);
        var near: [max_animators]Near = undefined;
        var count: usize = 0;
        for (items[0..n]) |item| {
            const animator = item orelse continue;
            const t = e.transform(animator) orelse continue;
            var at: Vec3 = .{};
            e.get_position(t, &at);
            near[count] = .{ .animator = animator, .distance = at.distance(eye) };
            count += 1;
        }
        std.mem.sort(Near, near[0..count], {}, Near.lessThan);
        for (near[0..@min(count, max_actors)]) |a| self.actor(a.animator, active);

        // Whatever wasn't posed this frame has its own back already, or is gone
        var it = self.tracked.iterator();
        while (it.next()) |kv| if (kv.value_ptr.frame != self.frame) self.tracked.removeByPtr(kv.key_ptr);
    }

    /// Main thread, with Unity's main camera, for drawing and picking bones.
    pub fn camera(self: *Posing, cam: *Object) void {
        if (!self.service.active()) return;
        var view: Mat4 = .identity;
        var projection: Mat4 = .identity;
        self.calls.world_to_camera(cam, &view);
        self.calls.projection(cam, &projection);
        self.service.camera(view, projection);
    }

    fn actor(self: *Posing, animator: *Object, active: bool) void {
        const c = &self.calls;
        const s = self.scratch;
        const root = self.engine.transform(animator) orelse return;
        var nodes: [max_bones]*Object = undefined;
        var parents: [max_bones]i32 = undefined;
        const count = walk(c, root, &nodes, &parents);
        // Not much of a skeleton
        if (count < 3) return;

        // The game's own pose back where it didn't set one since we posed it
        for (nodes[0..count], 0..) |t, i| {
            s.ids[i] = self.nativeOf(t);
            s.locals[i] = .read(c, t);
            const kv = self.tracked.fetchRemove(s.ids[i]) orelse continue;
            if (std.meta.eql(s.locals[i], kv.value.wrote)) {
                s.locals[i] = kv.value.game;
                s.locals[i].write(c, t);
            }
        }
        if (!active) return;

        self.names.ensureUnusedCapacity(gpa, @intCast(count + 1)) catch return;
        for (nodes[0..count], 0..) |t, i| {
            c.local_to_world(t, &s.matrices[i]);
            s.input[i] = s.matrices[i];
            s.bones[i] = .{ .name = self.nameOf(s.ids[i], t), .parent = parents[i] };
        }
        const id = self.nativeOf(animator);
        self.service.pose(.{ .id = id, .name = self.nameOf(id, animator), .bones = s.bones[0..count], .to_world = .identity }, &s.matrices[0]);

        // The root's parent is outside the skeleton, so it's worked out from how the root was
        const root_parent = (s.locals[0].matrix().inverse() orelse return).mul(s.input[0]);
        for (nodes[0..count], 0..) |t, i| {
            if (std.meta.eql(s.matrices[i], s.input[i])) continue;
            const parent = if (parents[i] >= 0) s.matrices[@intCast(parents[i])] else root_parent;
            const want: Local = .of(s.matrices[i].mul(parent.inverse() orelse continue));
            // Under a posed bone but not posed itself
            if (want.near(s.locals[i])) continue;
            want.write(c, t);
            // Unity tidies what it's given, so it's what it kept that tells if the game changed it
            self.tracked.put(gpa, s.ids[i], .{ .game = s.locals[i], .wrote = .read(c, t), .frame = self.frame }) catch {};
        }
    }

    fn nativeOf(self: *const Posing, object: *Object) usize {
        return local.load(usize, @intFromPtr(object) + self.cached_ptr) catch 0;
    }

    /// Cached, since asking Unity makes a string each time.
    fn nameOf(self: *Posing, id: usize, object: *Object) []const u8 {
        const got = self.names.getOrPutAssumeCapacity(id);
        if (!got.found_existing) {
            got.value_ptr.* = .{};
            if (self.calls.name(object)) |s| got.value_ptr.len = @intCast(readString(@intFromPtr(s), &got.value_ptr.buf).len);
        }
        got.value_ptr.frame = self.frame;
        return got.value_ptr.get();
    }

    fn dropOldNames(self: *Posing) void {
        var it = self.names.iterator();
        while (it.next()) |kv| if (self.frame -% kv.value_ptr.frame > name_frames) self.names.removeByPtr(kv.key_ptr);
    }
};

/// A C# string, the same under Mono and IL2CPP: the header, its length, then UTF-16. Anything past
/// ASCII is `?`, which is fine for telling bones apart.
fn readString(at: usize, buf: []u8) []const u8 {
    const len = local.load(i32, at + 2 * word) catch return "";
    var n: usize = 0;
    for (0..@min(@max(len, 0), buf.len)) |i| {
        const ch = local.load(u16, at + 2 * word + 4 + 2 * i) catch break;
        buf[n] = if (ch < 0x80) @intCast(ch) else '?';
        n += 1;
    }
    return buf[0..n];
}

/// The tree under `root` depth first, so parents come before their children. Gives how many.
fn walk(c: *const Calls, root: *Object, nodes: *[max_bones]*Object, parents: *[max_bones]i32) usize {
    const Next = struct { node: *Object, parent: i32 };
    var stack: [max_bones]Next = undefined;
    stack[0] = .{ .node = root, .parent = -1 };
    var top: usize = 1;
    var count: usize = 0;
    while (top > 0 and count < max_bones) {
        top -= 1;
        const at = stack[top];
        const i = count;
        nodes[i] = at.node;
        parents[i] = at.parent;
        count += 1;
        // Backwards, so the first child comes off first
        var k = c.child_count(at.node);
        while (k > 0 and top < stack.len) {
            k -= 1;
            const child = c.child(at.node, k) orelse continue;
            stack[top] = .{ .node = child, .parent = @intCast(i) };
            top += 1;
        }
    }
    return count;
}

const testing = std.testing;

test "a posed matrix goes back to the same local transform" {
    const l: Local = .{
        .position = .{ .x = 1, .y = 2, .z = 3 },
        .rotation = Quat.fromAxisAngle(.{ .y = 1 }, 0.7),
        .scale = .{ .x = 2, .y = 2, .z = 2 },
    };
    const back: Local = .of(l.matrix());
    try testing.expect(back.near(l));
    // Under a parent, the local part's what's left once the parent's taken off
    const parent: Local = .{ .position = .{ .x = 5 }, .rotation = Quat.fromAxisAngle(.{ .x = 1 }, 0.3), .scale = .{ .x = 1, .y = 1, .z = 1 } };
    const world = l.matrix().mul(parent.matrix());
    const again: Local = .of(world.mul(parent.matrix().inverse().?));
    try testing.expect(again.near(l));
}

test "strings read as ASCII" {
    const Str = extern struct { head: [2]usize = .{ 0, 0 }, len: i32, chars: [5]u16 };
    const s: Str = .{ .len = 5, .chars = .{ 'H', 'i', 'p', 0x263A, 's' } };
    var buf: [8]u8 = undefined;
    try testing.expectEqualStrings("Hip?s", readString(@intFromPtr(&s), &buf));
    var small: [2]u8 = undefined;
    try testing.expectEqualStrings("Hi", readString(@intFromPtr(&s), &small));
}
