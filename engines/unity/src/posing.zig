//! Hands posing each character's skeleton, once Unity's animated it and the game's LateUpdate
//! scripts have run, but before it's skinned and drawn. Characters are what's skinned: the scene's
//! SkinnedMeshRenderers, from its cached answers, with each mesh's bones in one ask. Meshes that
//! share a skeleton, like a body, its hair and clothes, are one character, named after what the
//! skeleton's under. The nearest to the camera get posing's slots. A frame's mostly a world matrix
//! per bone. Edits go back as each transform's local position, rotation and scale. Ones the game
//! doesn't set every frame get the game's own back the next frame, so edits don't pile up.

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
const log = sdk.log.scoped(.unity);

/// Posing's own limits
const max_bones = 512;
const max_actors = 32;
/// Meshes looked at a pick, nearest first
const max_meshes = 128;
/// How far up from a bone it looks for the rest of its skeleton
const max_climb = 64;
/// Of one character, like a body, its face and its lashes
const max_renderers = 16;
/// Blend shapes of one character, over all its meshes
const max_shapes = 512;
/// Unity's weights go to 100, posing's to 1
const unity_weight = 100;
const word = @sizeOf(usize);
const array_length = 3 * word;
const array_items = 4 * word;

/// Unity's engine calls for it, found like `Engine`'s.
const Calls = struct {
    parent: *const fn (*Object) callconv(.c) ?*Object,
    /// A SkinnedMeshRenderer's bones, a `Transform[]`
    bones: *const fn (*Object) callconv(.c) ?*Object,
    get_local_position: *const fn (*Object, *Vec3) callconv(.c) void,
    set_local_position: *const fn (*Object, *const Vec3) callconv(.c) void,
    get_local_rotation: *const fn (*Object, *Quat) callconv(.c) void,
    set_local_rotation: *const fn (*Object, *const Quat) callconv(.c) void,
    get_local_scale: *const fn (*Object, *Vec3) callconv(.c) void,
    set_local_scale: *const fn (*Object, *const Vec3) callconv(.c) void,
    local_to_world: *const fn (*Object, *Mat4) callconv(.c) void,

    const names = .{
        .parent = .{ "UnityEngine.Transform", "GetParent", "get_parentInternal" },
        .bones = .{ "UnityEngine.SkinnedMeshRenderer", "get_bones" },
        .get_local_position = .{ "UnityEngine.Transform", "get_localPosition_Injected", "INTERNAL_get_localPosition" },
        .set_local_position = .{ "UnityEngine.Transform", "set_localPosition_Injected", "INTERNAL_set_localPosition" },
        .get_local_rotation = .{ "UnityEngine.Transform", "get_localRotation_Injected", "INTERNAL_get_localRotation" },
        .set_local_rotation = .{ "UnityEngine.Transform", "set_localRotation_Injected", "INTERNAL_set_localRotation" },
        .get_local_scale = .{ "UnityEngine.Transform", "get_localScale_Injected", "INTERNAL_get_localScale" },
        .set_local_scale = .{ "UnityEngine.Transform", "set_localScale_Injected", "INTERNAL_set_localScale" },
        .local_to_world = .{ "UnityEngine.Transform", "get_localToWorldMatrix_Injected", "INTERNAL_get_localToWorldMatrix" },
    };
};

/// Unity's calls for blend shapes. Posing goes on without them if they aren't there.
const ShapeCalls = struct {
    shared_mesh: *const fn (*Object) callconv(.c) ?*Object,
    count: *const fn (*Object) callconv(.c) i32,
    /// A C# string
    name: *const fn (*Object, i32) callconv(.c) ?*Object,
    get_weight: *const fn (*Object, i32) callconv(.c) f32,
    set_weight: *const fn (*Object, i32, f32) callconv(.c) void,

    const names = .{
        .shared_mesh = .{ "UnityEngine.SkinnedMeshRenderer", "get_sharedMesh" },
        .count = .{ "UnityEngine.Mesh", "get_blendShapeCount" },
        .name = .{ "UnityEngine.Mesh", "GetBlendShapeName" },
        .get_weight = .{ "UnityEngine.SkinnedMeshRenderer", "GetBlendShapeWeight" },
        .set_weight = .{ "UnityEngine.SkinnedMeshRenderer", "SetBlendShapeWeight" },
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

    /// The game's own back where it hasn't set its own since, each of position, rotation and scale
    /// on its own, since a game often animates only some of them, like eyes that only turn.
    fn restored(t: Track, now: Local) Local {
        return .{
            .position = if (std.meta.eql(now.position, t.wrote.position)) t.game.position else now.position,
            .rotation = if (std.meta.eql(now.rotation, t.wrote.rotation)) t.game.rotation else now.rotation,
            .scale = if (std.meta.eql(now.scale, t.wrote.scale)) t.game.scale else now.scale,
        };
    }
};

/// The same for a blend shape, in Unity's weights.
const ShapeTrack = struct {
    game: f32,
    wrote: f32,
    frame: u32,
};

/// A blend shape, by its renderer and its place on that renderer's mesh.
const ShapeKey = struct {
    renderer: usize,
    index: i32,
};

/// One of a character's SkinnedMeshRenderers, held like its bones, and where its shapes are in the
/// character's list.
const Renderer = struct {
    object: *Object,
    native: usize,
    hold: u32,
    name: Name,
    /// What the shapes were read from, so a new mesh gets them read again. -1 till they're read.
    mesh_native: usize = 0,
    mesh_count: i32 = -1,
    first: u32 = 0,
    count: u32 = 0,
};

/// A character, in one of posing's slots. Its transforms are held through the game's runtime so the
/// garbage collector leaves them be, and each is checked against its native one before it's used,
/// in case Unity's destroyed it.
const Actor = struct {
    used: bool = false,
    /// It's kept by its skeleton's root, the first node
    native: usize = 0,
    name: Name = .{},
    count: u32 = 0,
    /// Parents before children, the root first
    nodes: [max_bones]*Object = undefined,
    natives: [max_bones]usize = undefined,
    parents: [max_bones]i32 = undefined,
    names: [max_bones]Name = undefined,
    node_holds: [max_bones]u32 = undefined,
    renderers: [max_renderers]Renderer = undefined,
    renderer_count: u32 = 0,
    /// Over all its renderers, each one's in a row
    shape_names: [max_shapes]Name = undefined,
    shape_count: u32 = 0,

    fn root(a: *const Actor) *Object {
        return a.nodes[0];
    }

    fn find(a: *const Actor, native: usize) ?u32 {
        for (a.natives[0..a.count], 0..) |n, i| if (n == native) return @intCast(i);
        return null;
    }
};

/// One mesh's bones, while picking.
const Mesh = struct {
    /// On its bones array and its root, which keep them till they're held themselves
    holds: [2]u32,
    /// The SkinnedMeshRenderer, held by the scene's answer
    renderer: *Object,
    renderer_native: usize,
    /// Its GameObject's
    name: Name,
    /// The mesh's own transform, which sits beside the skeleton under the model
    transform: *Object,
    bones: []*Object,
    natives: []usize,
    /// What's above all its bones, the bone at the top or what's over the ones at the top
    root: *Object,
    root_native: usize,
    distance: f32,
};
/// For the Timings window
var zone_read: sdk.timing.Zone = .init("Posing: reading bones");
var zone_hand: sdk.timing.Zone = .init("Posing: handing over");
var zone_write: sdk.timing.Zone = .init("Posing: writing back");
var zone_pick: sdk.timing.Zone = .init("Posing: finding characters");

/// What a frame works on, kept off Unity's main thread's stack.
const Scratch = struct {
    bones: [max_bones]W.PosingBone,
    matrices: [max_bones]Mat4,
    input: [max_bones]Mat4,
    shapes: [max_shapes]W.PosingShape,
    weights: [max_shapes]f32,
    weights_in: [max_shapes]f32,
};

pub const Posing = struct {
    service: W.Posing,
    calls: Calls,
    /// Null when this Unity hasn't got them
    shape_calls: ?ShapeCalls,
    engine: *const Engine,
    scene: *Scene,
    managed: W.Managed,
    scratch: *Scratch,
    actors: *[max_actors]Actor,
    // Main thread only from here down
    /// The scene's answer they were picked from
    picked: u32 = 0,
    tracked: std.AutoHashMapUnmanaged(usize, Track) = .empty,
    shapes_tracked: std.AutoHashMapUnmanaged(ShapeKey, ShapeTrack) = .empty,
    frame: u32 = 0,

    /// Null without posing. Blocks while the game's runtime looks, so not on the render thread.
    pub fn find(engine: *const Engine, scene: *Scene, managed: W.Managed, missing: *[]const u8) !?Posing {
        const service = (sdk.wraith.root() orelse return null).posing();
        for ([_]*sdk.timing.Zone{ &zone_read, &zone_hand, &zone_write, &zone_pick }) |z| sdk.timing.list(z);
        const calls = try engine_.findCalls(Calls, Calls.names, managed, missing);
        var shape_missing: []const u8 = "";
        const shape_calls = engine_.findCalls(ShapeCalls, ShapeCalls.names, managed, &shape_missing) catch null;
        if (shape_calls == null) log.info("No posing blend shapes, since this Unity's missing {s}", .{shape_missing});
        const scratch = try gpa.create(Scratch);
        errdefer gpa.destroy(scratch);
        return .{
            .service = service,
            .calls = calls,
            .shape_calls = shape_calls,
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
        self.shapes_tracked.deinit(gpa);
        gpa.destroy(self.scratch);
        gpa.destroy(self.actors);
    }

    /// Main thread, once everything's animated and before it's drawn.
    pub fn run(self: *Posing) void {
        self.frame +%= 1;
        const active = self.service.active();
        if (!active and self.tracked.count() == 0 and self.shapes_tracked.count() == 0) return;
        var found: std.ArrayList(scene_.Found) = .empty;
        defer found.deinit(gpa);
        const answer = self.scene.objectsOfType(gpa, "UnityEngine.SkinnedMeshRenderer", &found) catch 0;
        if (answer != self.picked) {
            self.picked = answer;
            const z = zone_pick.begin();
            defer z.end();
            self.pick(found.items);
        }
        for (self.actors) |*a| if (a.used) self.pose(a, active);

        // Whatever wasn't posed this frame has its own back already, or is gone
        var it = self.tracked.iterator();
        while (it.next()) |kv| if (kv.value_ptr.frame != self.frame) self.tracked.removeByPtr(kv.key_ptr);
        var shapes_it = self.shapes_tracked.iterator();
        while (shapes_it.next()) |kv| if (kv.value_ptr.frame != self.frame) self.shapes_tracked.removeByPtr(kv.key_ptr);
    }

    /// The characters nearest the camera. Ones already in a slot keep it, and their skeleton.
    fn pick(self: *Posing, found: []scene_.Found) void {
        var arena: std.heap.ArenaAllocator = .init(gpa);
        defer arena.deinit();
        const a = arena.allocator();

        const e = self.engine;
        var eye: Vec3 = .{};
        if (e.main_camera()) |cam| if (e.transform(cam)) |t| e.get_position(t, &eye);
        const ByDistance = struct {
            fn lessThan(at: Vec3, x: scene_.Found, y: scene_.Found) bool {
                return x.position.distance(at) < y.position.distance(at);
            }
        };
        std.mem.sort(scene_.Found, found, eye, ByDistance.lessThan);

        // Each mesh's bones, and what's at the top of them
        var meshes: std.ArrayList(Mesh) = .empty;
        defer for (meshes.items) |m| for (m.holds) |h| self.release(h);
        for (found[0..@min(found.len, max_meshes)]) |f| {
            var m = (self.meshOf(a, f) catch continue) orelse continue;
            m.distance = f.position.distance(eye);
            meshes.append(a, m) catch {
                for (m.holds) |h| self.release(h);
                break;
            };
        }
        const groups = groupMeshes(a, self, meshes.items) catch return;
        std.mem.sort(Group, groups, {}, struct {
            fn nearer(_: void, x: Group, y: Group) bool {
                return x.distance < y.distance;
            }
        }.nearer);
        const chosen = groups[0..@min(groups.len, max_actors)];

        // Let go of the ones that aren't near any more
        for (self.actors) |*actor| {
            if (!actor.used) continue;
            const still = for (chosen) |g| {
                if (g.root.root_native == actor.native) break true;
            } else false;
            if (!still) self.drop(actor);
        }
        for (chosen) |g| {
            const have = for (self.actors) |*actor| {
                if (actor.used and actor.native == g.root.root_native) break true;
            } else false;
            if (have) continue;
            const slot = for (self.actors) |*actor| {
                if (!actor.used) break actor;
            } else break;
            self.build(slot, g.root.root, g.root.root_native, g.meshes);
        }
    }

    /// A transform and what's above it, by native, for telling what's under what.
    fn above(self: *Posing, a: std.mem.Allocator, node: *Object, native: usize) ![]usize {
        var out: std.ArrayList(usize) = .empty;
        try out.append(a, native);
        var at = node;
        while (out.items.len < max_climb) {
            at = self.calls.parent(at) orelse break;
            try out.append(a, self.scene.nativeOf(at));
        }
        return out.items;
    }

    /// A SkinnedMeshRenderer's bones, in one ask. Null if it hasn't got a skeleton worth posing.
    fn meshOf(self: *Posing, a: std.mem.Allocator, f: scene_.Found) !?Mesh {
        if (!self.alive(f.object, f.native)) return null;
        // On the stack, where the garbage collector sees it, till they're held
        const array = self.calls.bones(f.object) orelse return null;
        const n = @min(std.mem.bytesToValue(usize, @as([*]const u8, @ptrFromInt(@intFromPtr(array) + array_length))[0..word]), max_bones);
        if (n < 3) return null;
        // Other asks can set the collector off, so it's held till the bones are
        const hold = self.managed.hold(@intFromPtr(array)) catch 0;
        errdefer self.release(hold);
        const items: [*]const ?*Object = @ptrFromInt(@intFromPtr(array) + array_items);
        const bones = try a.alloc(*Object, n);
        const natives = try a.alloc(usize, n);
        var count: usize = 0;
        for (items[0..n]) |item| {
            const b = item orelse continue;
            const native = self.scene.nativeOf(b);
            if (native == 0) continue;
            bones[count] = b;
            natives[count] = native;
            count += 1;
        }
        if (count < 3) {
            self.release(hold);
            return null;
        }
        // What's above all of them: the one whose parent isn't another of its bones, or what's over
        // all of those when there's more than one, like a rig's root that isn't a bone itself
        var top: ?*Object = null;
        for (bones[0..count]) |b| {
            const parent = self.calls.parent(b) orelse {
                top = if (top) |t| self.commonAbove(t, b) orelse t else b;
                continue;
            };
            if (std.mem.indexOfScalar(usize, natives[0..count], self.scene.nativeOf(parent)) != null) continue;
            top = if (top) |t| self.commonAbove(t, b) orelse t else b;
        }
        const root = top orelse bones[0];
        const root_native = self.scene.nativeOf(root);
        // It may not be one of the bones, so it's held too
        const root_hold = self.managed.hold(@intFromPtr(root)) catch 0;
        return .{ .holds = .{ hold, root_hold }, .renderer = f.object, .renderer_native = f.native, .name = f.name, .transform = f.transform, .bones = bones[0..count], .natives = natives[0..count], .root = root, .root_native = root_native, .distance = 0 };
    }

    /// The nearest transform both are, or are under. Null if they're in different trees.
    fn commonAbove(self: *Posing, x: *Object, y: *Object) ?*Object {
        var xs: [max_climb]usize = undefined;
        var objects: [max_climb]*Object = undefined;
        var n: usize = 0;
        var at: ?*Object = x;
        while (at) |t| : (at = self.calls.parent(t)) {
            if (n == xs.len) break;
            xs[n] = self.scene.nativeOf(t);
            objects[n] = t;
            n += 1;
        }
        at = y;
        var climbed: usize = 0;
        while (at) |t| : (at = self.calls.parent(t)) {
            if (std.mem.indexOfScalar(usize, xs[0..n], self.scene.nativeOf(t))) |i| return objects[i];
            climbed += 1;
            if (climbed == max_climb) break;
        }
        return null;
    }
    /// The skeleton under `root`, from all its meshes' bones and what's between them, parents first.
    fn build(self: *Posing, slot: *Actor, root: *Object, native: usize, meshes: []const *const Mesh) void {
        slot.* = .{ .used = true, .native = native };
        _ = self.add(slot, root, native, -1);
        const model = self.modelOf(root, meshes[0].transform);
        slot.name = self.scene.nameOf(model, self.scene.nativeOf(model));
        for (meshes) |m| for (m.bones, m.natives) |b, n| {
            _ = self.join(slot, b, n);
        };
        if (self.shape_calls == null) return;
        for (meshes) |m| {
            if (slot.renderer_count == max_renderers) break;
            slot.renderers[slot.renderer_count] = .{
                .object = m.renderer,
                .native = m.renderer_native,
                .hold = self.managed.hold(@intFromPtr(m.renderer)) catch 0,
                .name = m.name,
            };
            slot.renderer_count += 1;
        }
    }

    /// Reads each renderer's shape names again if its mesh isn't the one they came from, or one's
    /// gone, which comes out.
    fn readShapes(self: *Posing, a: *Actor) void {
        const sc = &(self.shape_calls orelse return);
        var stale = false;
        var kept: u32 = 0;
        for (a.renderers[0..a.renderer_count]) |r| {
            if (!self.alive(r.object, r.native)) {
                self.release(r.hold);
                stale = true;
                continue;
            }
            const mesh = sc.shared_mesh(r.object);
            const mesh_native = if (mesh) |m| self.scene.nativeOf(m) else 0;
            const n = if (mesh) |m| sc.count(m) else 0;
            if (mesh_native != r.mesh_native or n != r.mesh_count) stale = true;
            a.renderers[kept] = r;
            kept += 1;
        }
        a.renderer_count = kept;
        if (!stale) return;

        a.shape_count = 0;
        var buf: [48]u8 = undefined;
        for (a.renderers[0..a.renderer_count]) |*r| {
            const mesh = sc.shared_mesh(r.object);
            r.mesh_native = if (mesh) |m| self.scene.nativeOf(m) else 0;
            r.mesh_count = if (mesh) |m| sc.count(m) else 0;
            r.first = a.shape_count;
            r.count = 0;
            const m = mesh orelse continue;
            const n: u32 = @intCast(@max(r.mesh_count, 0));
            while (r.count < n and a.shape_count < max_shapes) : (r.count += 1) {
                const s = sc.name(m, @intCast(r.count));
                a.shape_names[a.shape_count] = if (s) |text| .init(scene_.readString(@intFromPtr(text), &buf)) else .{};
                a.shape_count += 1;
            }
        }
    }

    /// Hands over the actor's blend shapes after its bones, and writes back what posing changed.
    fn poseShapes(self: *Posing, a: *Actor, active: bool) void {
        const sc = &(self.shape_calls orelse return);
        const s = self.scratch;
        if (a.renderer_count == 0) return;
        self.readShapes(a);

        // The game's own weights back where it didn't set one since we posed it
        if (self.shapes_tracked.count() > 0) for (a.renderers[0..a.renderer_count]) |r| {
            for (0..r.count) |j| {
                const key: ShapeKey = .{ .renderer = r.native, .index = @intCast(j) };
                const kv = self.shapes_tracked.fetchRemove(key) orelse continue;
                if (sc.get_weight(r.object, key.index) == kv.value.wrote) sc.set_weight(r.object, key.index, kv.value.game);
            }
        };
        if (!active or a.shape_count == 0) return;

        for (a.renderers[0..a.renderer_count]) |r| for (0..r.count) |j| {
            const i = r.first + j;
            s.weights[i] = sc.get_weight(r.object, @intCast(j)) / unity_weight;
            s.weights_in[i] = s.weights[i];
            s.shapes[i] = .{ .name = a.shape_names[i].get(), .mesh = r.name.get() };
        };
        const count = a.shape_count;
        self.service.shapes(a.native, s.shapes[0..count], &s.weights[0]);

        for (a.renderers[0..a.renderer_count]) |r| for (0..r.count) |j| {
            const i = r.first + j;
            if (s.weights[i] == s.weights_in[i]) continue;
            const index: i32 = @intCast(j);
            const game = s.weights_in[i] * unity_weight;
            sc.set_weight(r.object, index, s.weights[i] * unity_weight);
            self.shapes_tracked.put(gpa, .{ .renderer = r.native, .index = index }, .{ .game = game, .wrote = sc.get_weight(r.object, index), .frame = self.frame }) catch {};
        };
    }

    /// What both the skeleton and its mesh are under, like `mdlCommando`, to name it after. Else
    /// what the skeleton's under, or its root.
    fn modelOf(self: *Posing, root: *Object, mesh: *Object) *Object {
        var mesh_up: [max_climb]usize = undefined;
        var n: usize = 0;
        var at: ?*Object = mesh;
        while (at) |t| : (at = self.calls.parent(t)) {
            if (n == mesh_up.len) break;
            mesh_up[n] = self.scene.nativeOf(t);
            n += 1;
        }
        at = self.calls.parent(root);
        var climbed: usize = 0;
        while (at) |t| : (at = self.calls.parent(t)) {
            if (std.mem.indexOfScalar(usize, mesh_up[0..n], self.scene.nativeOf(t)) != null) return t;
            climbed += 1;
            if (climbed == max_climb) break;
        }
        return self.calls.parent(root) orelse root;
    }

    /// Adds a bone, and anything between it and what's in already, so each is under its real parent.
    /// Null if it isn't under the root, or there's no room.
    fn join(self: *Posing, slot: *Actor, bone: *Object, native: usize) ?u32 {
        if (slot.find(native)) |i| return i;
        var chain: [max_climb]struct { node: *Object, native: usize } = undefined;
        var len: usize = 0;
        var at = bone;
        var at_native = native;
        const parent_index = while (len < max_climb) {
            chain[len] = .{ .node = at, .native = at_native };
            len += 1;
            at = self.calls.parent(at) orelse return null;
            at_native = self.scene.nativeOf(at);
            if (slot.find(at_native)) |i| break i;
        } else return null;
        // From the top down, so parents come first
        var parent: u32 = parent_index;
        while (len > 0) {
            len -= 1;
            parent = self.add(slot, chain[len].node, chain[len].native, @intCast(parent)) orelse return null;
        }
        return parent;
    }

    fn add(self: *Posing, slot: *Actor, node: *Object, native: usize, parent: i32) ?u32 {
        if (slot.count == max_bones) return null;
        const i = slot.count;
        slot.nodes[i] = node;
        slot.natives[i] = native;
        slot.parents[i] = parent;
        slot.names[i] = self.scene.nameOf(node, native);
        slot.node_holds[i] = self.managed.hold(@intFromPtr(node)) catch 0;
        slot.count += 1;
        return i;
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
        self.poseBones(a, active);
        // It may have gone
        if (a.used) self.poseShapes(a, active);
    }

    fn poseBones(self: *Posing, a: *Actor, active: bool) void {
        const c = &self.calls;
        const s = self.scratch;
        if (!self.alive(a.root(), a.native)) {
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
            const now: Local = .read(c, t);
            const back = kv.value.restored(now);
            if (!std.meta.eql(back, now)) back.write(c, t);
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
        for (a.renderers[0..a.renderer_count]) |r| self.release(r.hold);
        a.* = .{};
    }

    fn release(self: *Posing, hold: u32) void {
        if (hold != 0) self.managed.release(hold);
    }

    fn alive(self: *const Posing, object: *Object, native: usize) bool {
        return self.scene.alive(object, native);
    }
};

/// Meshes that are one character, with the one whose root's the skeleton's.
const Group = struct {
    root: *const Mesh,
    distance: f32,
    meshes: []const *const Mesh,
};

/// Meshes go together when one's root is on, or under, another's bones or root, like hair on a head,
/// or a glow skinned to the same bones as the body. The skeleton's root is the root that isn't under
/// a different one, the biggest mesh's if they're the same. Whatever order they came in.
fn groupMeshes(a: std.mem.Allocator, p: *Posing, meshes: []const Mesh) ![]Group {
    const n = meshes.len;
    const sets = try a.alloc(std.AutoHashMapUnmanaged(usize, void), n);
    const ups = try a.alloc([]usize, n);
    for (meshes, sets, ups) |*m, *set, *up| {
        set.* = .empty;
        for (m.natives) |native| try set.put(a, native, {});
        try set.put(a, m.root_native, {});
        up.* = try p.above(a, m.root, m.root_native);
    }
    const group_of = try a.alloc(usize, n);
    for (group_of, 0..) |*g, i| g.* = i;
    for (0..n) |j| for (0..n) |i| {
        if (i == j) continue;
        const under = for (ups[j]) |native| {
            if (sets[i].contains(native)) break true;
        } else false;
        if (under) unite(group_of, i, j);
    };

    const Building = struct { root: ?*const Mesh = null, biggest: ?*const Mesh = null, distance: f32 = std.math.floatMax(f32), meshes: std.ArrayList(*const Mesh) = .empty };
    const building = try a.alloc(Building, n);
    @memset(building, .{});
    for (meshes, 0..) |*m, j| {
        const g = &building[groupOf(group_of, j)];
        g.distance = @min(g.distance, m.distance);
        try g.meshes.append(a, m);
        if (g.biggest == null or m.bones.len > g.biggest.?.bones.len) g.biggest = m;
        // Under a different root, like hair's under the body's
        const under = for (meshes, 0..) |*other, i| {
            if (i == j or groupOf(group_of, i) != groupOf(group_of, j) or other.root_native == m.root_native) continue;
            if (std.mem.indexOfScalar(usize, ups[j][1..], other.root_native) != null) break true;
        } else false;
        if (!under and (g.root == null or m.bones.len > g.root.?.bones.len)) g.root = m;
    }
    var out: std.ArrayList(Group) = .empty;
    for (building) |g| {
        // Never left out, whatever shape it's in
        const root = g.root orelse g.biggest orelse continue;
        try out.append(a, .{ .root = root, .distance = g.distance, .meshes = g.meshes.items });
    }
    return out.items;
}
/// Union-find over meshes, which group they're in.
fn groupOf(group_of: []usize, i: usize) usize {
    var at = i;
    while (group_of[at] != at) at = group_of[at];
    return at;
}

fn unite(group_of: []usize, i: usize, j: usize) void {
    const x = groupOf(group_of, i);
    const y = groupOf(group_of, j);
    if (x != y) group_of[y] = x;
}

const testing = std.testing;

test "the game's own goes back on what it didn't set again, position, rotation and scale apart" {
    const game: Local = .{ .position = .{ .y = 1 }, .rotation = .identity, .scale = .{ .x = 1, .y = 1, .z = 1 } };
    const wrote: Local = .{ .position = .{ .y = 2 }, .rotation = Quat.fromAxisAngle(.{ .y = 1 }, 0.5), .scale = .{ .x = 1, .y = 1, .z = 1 } };
    const track: Track = .{ .game = game, .wrote = wrote, .frame = 0 };
    // Nothing set again, so it's all the game's
    try testing.expectEqual(game, track.restored(wrote));
    // An eye the game only turns keeps its new turn, and gets its own place back, not posing's
    var turned = wrote;
    turned.rotation = Quat.fromAxisAngle(.{ .x = 1 }, 0.2);
    const back = track.restored(turned);
    try testing.expectEqual(game.position, back.position);
    try testing.expectEqual(turned.rotation, back.rotation);
}

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

/// Pretend Unity objects for picking: each has its native at `m_CachedPtr`, a name as a C# string,
/// a parent, and maybe bones.
const FakeUnity = struct {
    const cached_ptr = 2 * @sizeOf(usize);

    const Str = extern struct {
        header: [2]usize = .{ 0, 0 },
        len: i32 = 0,
        chars: [24]u16 = @splat(0),
    };

    const Thing = extern struct {
        header: [2]usize = .{ 0, 0 },
        native: usize = 0,
        name: Str = .{},
        parent: ?*Thing = null,
        /// A `Transform[]`, for a mesh
        bones: extern struct { header: [2]usize = .{ 0, 0 }, bounds: usize = 0, len: usize = 0, items: [8]?*Thing = @splat(null) } = .{},

        fn init(self: *Thing, native: usize, label: []const u8, up: ?*Thing) void {
            self.* = .{ .native = native, .parent = up };
            self.name.len = @intCast(label.len);
            for (label, 0..) |ch, i| self.name.chars[i] = ch;
        }

        fn setBones(self: *Thing, list: []const *Thing) void {
            self.bones.len = list.len;
            for (list, 0..) |b, i| self.bones.items[i] = b;
        }

        fn obj(self: *Thing) *Object {
            return @ptrCast(self);
        }
    };

    fn of(o: *Object) *Thing {
        return @ptrCast(@alignCast(o));
    }

    fn name(o: *Object) callconv(.c) ?*Object {
        return @ptrCast(&of(o).name);
    }

    fn parent(o: *Object) callconv(.c) ?*Object {
        return if (of(o).parent) |p| p.obj() else null;
    }

    fn bones(o: *Object) callconv(.c) ?*Object {
        return @ptrCast(&of(o).bones);
    }

    fn noCamera() callconv(.c) ?*Object {
        return null;
    }
};

test "characters are found from their meshes' bones, a body and its hair as one" {
    const T = FakeUnity.Thing;
    var world: T = undefined;
    var model: T = undefined;
    var body_mesh: T = undefined;
    var hair_mesh: T = undefined;
    var armature: T = undefined;
    var hips: T = undefined;
    var spine: T = undefined;
    var head: T = undefined;
    var hair_root: T = undefined;
    var hair_tip: T = undefined;
    var prop: T = undefined;
    var prop_bone: T = undefined;
    world.init(1, "World", null);
    model.init(2, "Model", &world);
    body_mesh.init(3, "Body", &model);
    hair_mesh.init(4, "Hair", &model);
    armature.init(5, "Armature", &model);
    hips.init(6, "Hips", &armature);
    spine.init(7, "Spine", &hips);
    head.init(8, "Head", &spine);
    hair_root.init(9, "HairRoot", &head);
    hair_tip.init(10, "HairTip", &hair_root);
    prop.init(11, "Lamp", &world);
    prop_bone.init(12, "Shade", &prop);
    body_mesh.setBones(&.{ &hips, &spine, &head });
    // The hair's own bones start below the body's, so it's found by what's above it, and what's
    // between comes from climbing. Nearer, and as big as the body, so order can't decide it
    hair_mesh.setBones(&.{ &hair_tip, &hair_root, &hair_tip });
    // Too few bones to pose
    prop.setBones(&.{ &prop_bone, &prop });

    const engine: Engine = .{
        .main_camera = FakeUnity.noCamera,
        .transform = undefined,
        .get_position = undefined,
        .set_position = undefined,
        .get_rotation = undefined,
        .set_rotation = undefined,
        .get_fov = undefined,
        .set_fov = undefined,
        .frame_count = undefined,
        .world_to_camera = undefined,
        .projection = undefined,
        .local_to_world = undefined,
    };
    var scene: Scene = .{ .managed = .{}, .engine = &engine, .calls = .{ .find_objects = undefined, .name = FakeUnity.name }, .cached_ptr = FakeUnity.cached_ptr };
    defer scene.deinit();
    var calls: Calls = undefined;
    calls.parent = FakeUnity.parent;
    calls.bones = FakeUnity.bones;
    var actors: [max_actors]Actor = @splat(.{});
    var posing: Posing = .{ .service = undefined, .calls = calls, .shape_calls = null, .engine = &engine, .scene = &scene, .managed = .{}, .scratch = undefined, .actors = &actors };

    var found = [_]scene_.Found{
        .{ .object = hair_mesh.obj(), .native = 4, .transform = hair_mesh.obj(), .transform_native = 4, .name = .init("Hair"), .position = .{ .x = 1 } },
        .{ .object = prop.obj(), .native = 11, .transform = prop.obj(), .transform_native = 11, .name = .init("Lamp"), .position = .{ .x = 2 } },
        .{ .object = body_mesh.obj(), .native = 3, .transform = body_mesh.obj(), .transform_native = 3, .name = .init("Body"), .position = .{ .x = 3 } },
    };
    posing.pick(&found);

    var used: usize = 0;
    for (actors) |a| used += @intFromBool(a.used);
    try testing.expectEqual(1, used);
    const a = &actors[0];
    try testing.expectEqualStrings("Model", a.name.get());
    try testing.expectEqual(6, a.native);
    const want = [_]struct { []const u8, i32 }{ .{ "Hips", -1 }, .{ "Spine", 0 }, .{ "Head", 1 }, .{ "HairRoot", 2 }, .{ "HairTip", 3 } };
    try testing.expectEqual(want.len, a.count);
    for (want, 0..) |w, i| {
        try testing.expectEqualStrings(w[0], a.names[i].get());
        try testing.expectEqual(w[1], a.parents[i]);
    }

    // Picked again, it keeps its slot and skeleton
    posing.pick(&found);
    try testing.expect(actors[0].used and actors[0].count == want.len);
}

test "a body and a glow on the same bones, with two tops under a root that isn't a bone, are one" {
    const T = FakeUnity.Thing;
    var model: T = undefined;
    var body_mesh: T = undefined;
    var glow_mesh: T = undefined;
    var armature: T = undefined;
    var root: T = undefined;
    var base: T = undefined;
    var pelvis: T = undefined;
    var spine: T = undefined;
    var center: T = undefined;
    var eye: T = undefined;
    model.init(1, "mdlDroneTech", null);
    body_mesh.init(2, "Body", &model);
    glow_mesh.init(3, "Glow", &model);
    armature.init(4, "Armature", &model);
    root.init(5, "ROOT", &armature);
    base.init(6, "base", &root);
    pelvis.init(7, "pelvis", &base);
    spine.init(8, "spine", &pelvis);
    center.init(9, "drone_center_M", &root);
    eye.init(10, "drone_eye", &center);
    // The center's first, so taking the first top would leave out the body
    body_mesh.setBones(&.{ &center, &eye, &base, &pelvis, &spine });
    glow_mesh.setBones(&.{ &center, &eye, &base, &pelvis, &spine });

    const engine: Engine = .{
        .main_camera = FakeUnity.noCamera,
        .transform = undefined,
        .get_position = undefined,
        .set_position = undefined,
        .get_rotation = undefined,
        .set_rotation = undefined,
        .get_fov = undefined,
        .set_fov = undefined,
        .frame_count = undefined,
        .world_to_camera = undefined,
        .projection = undefined,
        .local_to_world = undefined,
    };
    var scene: Scene = .{ .managed = .{}, .engine = &engine, .calls = .{ .find_objects = undefined, .name = FakeUnity.name }, .cached_ptr = FakeUnity.cached_ptr };
    defer scene.deinit();
    var calls: Calls = undefined;
    calls.parent = FakeUnity.parent;
    calls.bones = FakeUnity.bones;
    var actors: [max_actors]Actor = @splat(.{});
    var posing: Posing = .{ .service = undefined, .calls = calls, .shape_calls = null, .engine = &engine, .scene = &scene, .managed = .{}, .scratch = undefined, .actors = &actors };

    var found = [_]scene_.Found{
        .{ .object = glow_mesh.obj(), .native = 3, .transform = glow_mesh.obj(), .transform_native = 3, .name = .init("Glow"), .position = .{ .x = 1 } },
        .{ .object = body_mesh.obj(), .native = 2, .transform = body_mesh.obj(), .transform_native = 2, .name = .init("Body"), .position = .{ .x = 2 } },
    };
    posing.pick(&found);

    var used: usize = 0;
    for (actors) |a| used += @intFromBool(a.used);
    try testing.expectEqual(1, used);
    const a = &actors[0];
    try testing.expectEqualStrings("mdlDroneTech", a.name.get());
    try testing.expectEqualStrings("ROOT", a.names[0].get());
    try testing.expectEqual(6, a.count);
    // Every bone's under its real parent
    for (1..a.count) |i| try testing.expect(a.parents[i] >= 0 and a.parents[i] < i);
}
