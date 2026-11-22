//! Hands posing each character's skeleton, once Unity's animated it and the game's LateUpdate
//! scripts have run, but before it's skinned and drawn. Characters are the Animators nearest the
//! camera, from the scene's cached answers, and a skeleton is the transforms under one. Each is
//! walked once and kept, a few new ones a frame, so a frame's mostly a world matrix per bone. Edits go back as each transform's local position, rotation
//! and scale. Ones the game doesn't set every frame get the game's own back the next frame, so edits
//! don't pile up.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");

const engine_ = @import("engine.zig");
const Engine = engine_.Engine;
const Object = engine_.Object;
const scene_ = @import("scene.zig");
const Scene = scene_.Scene;
const Name = scene_.Name;

const W = sdk.api.wraith;
const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;
const Mat4 = sdk.math.Mat4;
const gpa = std.heap.smp_allocator;

/// Posing's own limits
const max_bones = 512;
const max_actors = 32;

/// Unity's engine calls for it, found like `Engine`'s.
const Calls = struct {
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

/// A character, in one of posing's slots. Its objects are held through the game's runtime so the
/// garbage collector leaves them be, and each is checked against its native one before it's used,
/// in case Unity's destroyed it.
const Actor = struct {
    used: bool = false,
    /// The Animator
    animator: *Object = undefined,
    native: usize = 0,
    transform: *Object = undefined,
    transform_native: usize = 0,
    /// On the Animator and its Transform
    holds: [2]u32 = .{ 0, 0 },
    name: Name = .{},
    /// Walking it can take a few frames, carrying on from `stack`
    walked: bool = false,
    count: u32 = 0,
    nodes: [max_bones]*Object = undefined,
    natives: [max_bones]usize = undefined,
    parents: [max_bones]i32 = undefined,
    names: [max_bones]Name = undefined,
    /// On each node, 0 for the root, which `holds` has
    node_holds: [max_bones]u32 = undefined,
    stack: [max_bones]Next = undefined,
    top: u32 = 0,
};

/// A transform still to walk.
const Next = struct { node: *Object, native: usize, parent: i32, hold: u32 };

/// For the Timings window
var zone_read: sdk.timing.Zone = .init("Posing: reading bones");
var zone_hand: sdk.timing.Zone = .init("Posing: handing over");
var zone_write: sdk.timing.Zone = .init("Posing: writing back");
var zone_walk: sdk.timing.Zone = .init("Posing: walking new ones");

/// How long a frame can spend walking new characters, as that asks Unity about every bone, and
/// Unity makes C# objects and strings for ones the game's never touched
const walk_budget_ns = std.time.ns_per_ms / 2;
/// Transforms walked a frame however long they take, so it always gets somewhere
const min_walk = 16;

/// What a frame works on, kept off Unity's main thread's stack.
const Scratch = struct {
    bones: [max_bones]schema.PosingBone,
    matrices: [max_bones]Mat4,
    input: [max_bones]Mat4,
};

pub const Posing = struct {
    service: schema.Posing,
    calls: Calls,
    engine: *const Engine,
    scene: *Scene,
    managed: W.Managed,
    scratch: *Scratch,
    actors: *[max_actors]Actor,
    // Main thread only from here down
    /// The scene's answer they were picked from
    picked: u32 = 0,
    tracked: std.AutoHashMapUnmanaged(usize, Track) = .empty,
    frame: u32 = 0,

    /// Null without posing. Blocks while the game's runtime looks, so not on the render thread.
    pub fn find(engine: *const Engine, scene: *Scene, managed: W.Managed, missing: *[]const u8) !?Posing {
        const service = sdk.salamander.service(schema.Posing, "posing") orelse return null;
        for ([_]*sdk.timing.Zone{ &zone_read, &zone_hand, &zone_write, &zone_walk }) |z| sdk.timing.list(z);
        const calls = try engine_.findCalls(Calls, Calls.names, managed, missing);
        const scratch = try gpa.create(Scratch);
        errdefer gpa.destroy(scratch);
        return .{
            .service = service,
            .calls = calls,
            .engine = engine,
            .scene = scene,
            .managed = managed,
            .scratch = scratch,
            .actors = blk: {
                const actors = try gpa.create([max_actors]Actor);
                for (actors) |*a| a.* = .{};
                break :blk actors;
            },
        };
    }

    pub fn deinit(self: *Posing) void {
        for (self.actors) |*a| if (a.used) self.drop(a);
        self.tracked.deinit(gpa);
        gpa.destroy(self.scratch);
        gpa.destroy(self.actors);
    }

    /// Main thread, once everything's animated and before it's drawn.
    pub fn run(self: *Posing) void {
        self.frame +%= 1;
        const active = self.service.active();
        if (!active and self.tracked.count() == 0) return;
        var found: std.ArrayList(scene_.Found) = .empty;
        defer found.deinit(gpa);
        const answer = self.scene.objectsOfType(gpa, "UnityEngine.Animator", &found) catch 0;
        if (answer != self.picked) {
            self.picked = answer;
            self.pick(found.items);
        }
        // Walking first, on its own clock, so time spent posing can't starve it
        {
            const z = zone_walk.begin();
            defer z.end();
            const walk_until = sdk.timing.now() + walk_budget_ns;
            var at_least: usize = min_walk;
            for (self.actors) |*a| {
                if (!a.used or a.walked) continue;
                if (at_least == 0 and sdk.timing.now() >= walk_until) break;
                at_least -|= self.walk(a, walk_until, at_least);
            }
        }
        for (self.actors) |*a| if (a.used and a.walked) self.pose(a, active);

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
        const d3d = toD3d(view, projection);
        self.service.camera(d3d.view, d3d.projection);
    }

    /// The Animators nearest the camera. Ones already in a slot keep it, and their skeleton.
    fn pick(self: *Posing, found: []scene_.Found) void {
        const e = self.engine;
        var eye: Vec3 = .{};
        if (e.main_camera()) |cam| if (e.transform(cam)) |t| e.get_position(t, &eye);
        const ByDistance = struct {
            fn lessThan(at: Vec3, x: scene_.Found, y: scene_.Found) bool {
                return x.position.distance(at) < y.position.distance(at);
            }
        };
        std.mem.sort(scene_.Found, found, eye, ByDistance.lessThan);
        const chosen = found[0..@min(found.len, max_actors)];
        // Let go of the ones that aren't near any more
        for (self.actors) |*a| {
            if (!a.used) continue;
            const still = for (chosen) |f| {
                if (f.native == a.native) break true;
            } else false;
            if (!still) {
                self.drop(a);
            }
        }
        for (chosen) |f| {
            const have = for (self.actors) |*a| {
                if (a.used and a.native == f.native) break true;
            } else false;
            if (have) continue;
            const slot = for (self.actors) |*a| {
                if (!a.used) break a;
            } else break;
            slot.used = true;
            slot.holds = .{ self.managed.hold(@intFromPtr(f.object)) catch 0, self.managed.hold(@intFromPtr(f.transform)) catch 0 };
            slot.animator = f.object;
            slot.native = f.native;
            slot.transform = f.transform;
            slot.transform_native = f.transform_native;
            slot.name = f.name;
            slot.walked = false;
            slot.count = 0;
            slot.top = 0;
        }
    }

    /// The transforms under its Animator, parents first, till `until` once it's done `at_least`.
    /// Carries on next time. Gives how many it did.
    fn walk(self: *Posing, a: *Actor, until: u64, at_least: usize) usize {
        var done: usize = 0;
        if (a.count == 0 and a.top == 0) {
            if (!self.alive(a.transform, a.transform_native)) {
                self.drop(a);
                return 0;
            }
            a.stack[0] = .{ .node = a.transform, .native = a.transform_native, .parent = -1, .hold = 0 };
            a.top = 1;
        }
        const s = self.scene;
        const c = &self.calls;
        while (a.top > 0 and a.count < max_bones) {
            if (done >= at_least and sdk.timing.now() >= until) return done;
            done += 1;
            a.top -= 1;
            const at = a.stack[a.top];
            // It might have gone since the last frame
            if (!self.alive(at.node, at.native)) {
                self.release(at.hold);
                continue;
            }
            const i = a.count;
            a.nodes[i] = at.node;
            a.node_holds[i] = at.hold;
            a.natives[i] = at.native;
            a.parents[i] = at.parent;
            a.names[i] = s.nameOf(at.node, at.native);
            a.count += 1;
            // Backwards, so the first child comes off first
            var k = c.child_count(at.node);
            while (k > 0 and a.top < max_bones) {
                k -= 1;
                const child = c.child(at.node, k) orelse continue;
                const native = s.nativeOf(child);
                if (native == 0) continue;
                // Held, as it might wait for the next frame, and Unity may have only just made it
                a.stack[a.top] = .{ .node = child, .native = native, .parent = @intCast(i), .hold = self.managed.hold(@intFromPtr(child)) catch 0 };
                a.top += 1;
            }
        }
        // What's left past the most bones it takes
        while (a.top > 0) {
            a.top -= 1;
            self.release(a.stack[a.top].hold);
        }
        a.walked = true;
        // Not much of a skeleton, so it's not offered
        if (a.count < 3) {
            self.drop(a);
        }
        return done;
    }

    /// Bones the game's destroyed, like effects on a hand, come out, along with what was under them.
    fn dropDead(self: *Posing, a: *Actor) void {
        var to: [max_bones]i32 = undefined;
        var n: u32 = 0;
        for (0..a.count) |i| {
            const p = a.parents[i];
            const kept = self.alive(a.nodes[i], a.natives[i]) and (p < 0 or to[@intCast(p)] >= 0);
            if (!kept) {
                to[i] = -1;
                self.release(a.node_holds[i]);
                continue;
            }
            to[i] = @intCast(n);
            a.nodes[n] = a.nodes[i];
            a.node_holds[n] = a.node_holds[i];
            a.natives[n] = a.natives[i];
            a.names[n] = a.names[i];
            a.parents[n] = if (p < 0) -1 else to[@intCast(p)];
            n += 1;
        }
        a.count = n;
    }

    fn pose(self: *Posing, a: *Actor, active: bool) void {
        const c = &self.calls;
        const s = self.scratch;
        if (!self.alive(a.animator, a.native) or !self.alive(a.transform, a.transform_native)) {
            return self.drop(a);
        }
        for (a.nodes[0..a.count], a.natives[0..a.count]) |t, native| if (!self.alive(t, native)) {
            self.dropDead(a);
            break;
        };
        const count = a.count;
        if (count == 0) {
            return self.drop(a);
        }

        // The game's own pose back where it didn't set one since we posed it
        if (self.tracked.count() > 0) for (a.nodes[0..count], a.natives[0..count]) |t, native| {
            const kv = self.tracked.fetchRemove(native) orelse continue;
            if (std.meta.eql(Local.read(c, t), kv.value.wrote)) kv.value.game.write(c, t);
        };
        if (!active) return;

        {
            const z = zone_read.begin();
            defer z.end();
            for (a.nodes[0..count], a.parents[0..count], a.names[0..count], 0..) |t, parent, *name, i| {
                c.local_to_world(t, &s.matrices[i]);
                s.input[i] = s.matrices[i];
                s.bones[i] = .{ .name = name.get(), .parent = parent };
            }
        }
        const hand = zone_hand.begin();
        self.service.pose(.{ .id = a.native, .name = a.name.get(), .bones = s.bones[0..count], .to_world = .identity }, &s.matrices[0]);
        hand.end();
        const write = zone_write.begin();
        defer write.end();

        // The root's parent is outside the skeleton, so it's worked out from how the root was
        var root_parent: ?Mat4 = null;
        for (a.nodes[0..count], a.natives[0..count], a.parents[0..count], 0..) |t, native, p, i| {
            if (std.meta.eql(s.matrices[i], s.input[i])) continue;
            const parent = if (p >= 0) s.matrices[@intCast(p)] else root_parent orelse blk: {
                const root: Local = .read(c, a.nodes[0]);
                root_parent = (root.matrix().inverse() orelse return).mul(s.input[0]);
                break :blk root_parent.?;
            };
            const want: Local = .of(s.matrices[i].mul(parent.inverse() orelse continue));
            const game: Local = .read(c, t);
            // Under a posed bone but not posed itself
            if (want.near(game)) continue;
            want.write(c, t);
            // Unity tidies what it's given, so it's what it kept that tells if the game changed it
            self.tracked.put(gpa, native, .{ .game = game, .wrote = .read(c, t), .frame = self.frame }) catch {};
        }
    }

    /// Out of its slot, letting go of what it held.
    fn drop(self: *Posing, a: *Actor) void {
        for (a.node_holds[0..a.count]) |h| self.release(h);
        for (a.stack[0..a.top]) |n| self.release(n.hold);
        for (a.holds) |h| self.release(h);
        a.* = .{};
    }

    fn release(self: *Posing, hold: u32) void {
        if (hold != 0) self.managed.release(hold);
    }

    fn alive(self: *const Posing, object: *Object, native: usize) bool {
        return self.scene.alive(object, native);
    }
};

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
