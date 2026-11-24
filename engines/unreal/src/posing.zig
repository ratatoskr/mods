//! Hands posing the nearest characters' skeletons as Unreal animates them. Edits go in at their
//! anim instance's post-evaluate, after IK and before the component places what's held in its
//! bones' sockets, into the bones it's just animated, so held things follow and they're drawn with
//! the edits, as Kai and Brio do it.
//!
//! While posing's open, the meshes being posed are held so the engine animates every bone of them
//! every frame: at their full detail, with no update rate optimizations or tick interval, which
//! games use to animate far or minor characters less. In a paused world they're kept ticking with
//! their animation's rate at 0, along with meshes that copy their bones, like clothes. It all goes
//! back as posing closes. Blend shapes, morph targets in Unreal, go through morphs.zig.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;

const Unreal = @import("ue/Unreal.zig");
const FName = Unreal.FName;
const Loop = @import("loop.zig").Loop;
const World = @import("ue/World.zig");
const Meshes = @import("meshes.zig").Meshes;
const morphs_ = @import("morphs.zig");
const Morphs = morphs_.Morphs;

const Mat4 = sdk.math.Mat4;
const gpa = std.heap.smp_allocator;
const log = sdk.log.scoped(.unreal);

const max_bones = 512;
/// The meshes being posed, and their followers.
const max_held = 128;
/// Frames held meshes keep ticking once posing closes in a paused world, so they're drawn
/// without the edits again.
const release_after = 3;
/// Writes remembered for each bone. Unreal 4.18 passes three arrays around.
const wrote_kept = 4;

pub const Offsets = struct {
    bone_name: Unreal.Call,
    parent_bone: Unreal.Call,
    /// `ActorComponent.SetTickableWhenPaused`, and `PrimaryComponentTick.bTickEvenWhenPaused` for
    /// what it was.
    tickable: ?Unreal.Call,
    tickable_bit: ?Unreal.Bit,
    /// `SkeletalMeshComponent.GlobalAnimRateScale`.
    rate: ?usize,
    /// `SkinnedMeshComponent.SetForcedLOD`, 1 for the most detailed, and `ForcedLodModel`.
    forced_lod: ?Unreal.Call,
    forced_lod_at: ?usize,
    /// `SkinnedMeshComponent.bEnableUpdateRateOptimizations`.
    uro: ?Unreal.Bit,
    /// `PrimaryComponentTick.TickInterval`.
    interval: ?usize,
    skinned: usize,
    /// `LeaderPoseComponent`, `MasterPoseComponent` before UE5.1, a weak pointer to the mesh a
    /// mesh copies its bones from.
    leader: ?usize,
};

/// A character's skeleton, and what it was before posing's edits.
const Skeleton = struct {
    /// All its bones, and how many posing gets, which can be fewer.
    total: u32,
    count: u32,
    name: []const u8,
    bones: []W.PosingBone,
    /// As the game last animated it.
    base: []Mat4,
    edited: bool = false,
    /// Hashes of what posing last wrote into each bone, the last few times, 0 where it didn't.
    wrote: [][wrote_kept]u64,
    ring: u8 = 0,
    /// Its blend shapes, over it and the meshes that follow it.
    shapes: []morphs_.Shape = &.{},
    shape_list: []W.PosingShape = &.{},
    arena: std.heap.ArenaAllocator,
};

/// A mesh that copies its bones from another, by the other's object index.
const Follower = struct { leader: u32, component: usize };

/// A mesh being held, and what to put back.
const Held = struct {
    component: usize,
    /// Copies its bones from a held mesh, so it's only kept ticking through a pause.
    follower: bool = false,
    uro: bool = false,
    interval: f32 = 0,
    lod: i32 = 0,
    /// At full detail, once the player's picked it or edited it, till posing closes.
    detailed: bool = false,
    /// Set while it's kept ticking through a pause.
    frozen: ?struct { rate: f32, tickable: bool } = null,
};

const Scratch = struct {
    matrices: [max_bones]Mat4,
    input: [max_bones]Mat4,
    stale: [max_bones]bool,
    weights: [morphs_.max_shapes]f32,
    weights_in: [morphs_.max_shapes]f32,
};

pub const Posing = struct {
    service: W.Posing,
    ue: *const Unreal,
    loop: *Loop,
    meshes: *Meshes,
    world: *const World,
    off: Offsets,
    /// Null if this Unreal's missing what blend shapes need.
    morphs: ?Morphs,
    scratch: *Scratch,
    // Game thread only from here down
    skeletons: std.AutoHashMapUnmanaged(usize, Skeleton) = .empty,
    held: std.ArrayList(Held) = .empty,
    /// Every mesh that follows another, found as posing opens and as the world pauses.
    followers: std.ArrayList(Follower) = .empty,
    was_active: bool = false,
    was_paused: bool = false,
    release_in: u8 = 0,
    active: bool = false,

    /// Null without posing.
    pub fn find(ue: *const Unreal, loop: *Loop, meshes: *Meshes, world: *const World, missing: *[]const u8) !?Posing {
        const service = (sdk.wraith.root() orelse return null).posing();
        const names = [_][]const u8{ "SkinnedMeshComponent", "SkeletalMeshComponent", "ActorComponent", "TickFunction" };
        var found: [names.len]usize = undefined;
        ue.findIn("/Script/Engine", &names, &found);
        for (names[0..3], found[0..3]) |n, f| if (f == 0) {
            missing.* = n;
            return error.MissingClass;
        };
        const skinned, const skeletal, const component, const tick_function = found;
        var ignored: []const u8 = "";
        const tick_at = if (tick_function != 0) ue.offsetOf(component, "PrimaryComponentTick") else null;
        const off: Offsets = .{
            .bone_name = try ue.callOf(skinned, "GetBoneName", &.{ "BoneIndex", "ReturnValue" }, missing),
            .parent_bone = try ue.callOf(skinned, "GetParentBone", &.{ "BoneName", "ReturnValue" }, missing),
            .tickable = ue.callOf(component, "SetTickableWhenPaused", &.{"bTickableWhenPaused"}, &ignored) catch null,
            .tickable_bit = if (tick_at) |t| if (ue.bitOf(tick_function, "bTickEvenWhenPaused")) |b| .{ .offset = t + b.offset, .mask = b.mask } else null else null,
            .rate = ue.offsetOf(skeletal, "GlobalAnimRateScale"),
            .forced_lod = ue.callOf(skinned, "SetForcedLOD", &.{"InNewForcedLOD"}, &ignored) catch null,
            .forced_lod_at = ue.offsetOf(skinned, "ForcedLodModel"),
            .uro = ue.bitOf(skinned, "bEnableUpdateRateOptimizations"),
            .interval = if (tick_at) |t| if (ue.offsetOf(tick_function, "TickInterval")) |i| t + i else null else null,
            .skinned = skinned,
            .leader = ue.offsetOf(skinned, "LeaderPoseComponent") orelse ue.offsetOf(skinned, "MasterPoseComponent"),
        };
        if (off.tickable == null or off.rate == null) log.info("Posing while the world's paused won't show, since this Unreal's missing SetTickableWhenPaused or GlobalAnimRateScale", .{});
        var morph_missing: []const u8 = "";
        const morphs = Morphs.find(ue, loop, &morph_missing) catch |err| blk: {
            log.info("No posing blend shapes, since this Unreal's missing {s}: {t}", .{ morph_missing, err });
            break :blk null;
        };
        return .{
            .service = service,
            .ue = ue,
            .loop = loop,
            .meshes = meshes,
            .world = world,
            .off = off,
            .morphs = morphs,
            .scratch = try gpa.create(Scratch),
        };
    }

    pub fn deinit(self: *Posing) void {
        var it = self.skeletons.valueIterator();
        while (it.next()) |s| s.arena.deinit();
        self.skeletons.deinit(gpa);
        self.held.deinit(gpa);
        self.followers.deinit(gpa);
        gpa.destroy(self.scratch);
    }

    /// Game thread, once a tick, after `Meshes.tick`.
    pub fn tick(self: *Posing) void {
        self.active = self.service.active();
        self.meshes.precise = self.active;
        const paused = self.world.paused();
        // What follows what, as posing opens, and again as the world pauses
        if (self.active and (!self.was_active or (paused and !self.was_paused))) self.findFollowers();
        // Closed, nothing's posed, so the blend shapes go back to the game's
        if (self.was_active and !self.active) self.unshapeAll();
        self.was_active = self.active;
        self.holdWhileOpen(paused);
        self.was_paused = paused;
        // A skeleton of a mesh the game's done with, one a tick
        var it = self.skeletons.iterator();
        while (it.next()) |kv| {
            if (self.meshes.get(kv.key_ptr.*) != null) continue;
            kv.value_ptr.arena.deinit();
            self.skeletons.removeByPtr(kv.key_ptr);
            break;
        }
    }

    /// Game thread, as a mesh's been animated.
    pub fn onAnimated(raw: *anyopaque, component: usize) void {
        const self: *Posing = @ptrCast(@alignCast(raw));
        if (!self.active or !self.meshes.bones.ready() or !self.meshes.isNearest(component)) return;
        self.pose(component);
    }

    /// Hands posing the bones the game's just animated, and writes back what it changes.
    fn pose(self: *Posing, component: usize) void {
        const mesh = self.meshes.get(component) orelse return;
        const bones = self.meshes.bones.justAnimated(component) orelse return;
        const sk = self.skeletonOf(component, bones.count) orelse return;
        const layout = self.meshes.bones.layout;
        const n = sk.count;
        const stride = layout.size();
        const s = self.scratch;
        // Bones the game didn't animate again still have what posing wrote, like ones nothing's
        // skinned to, which Unreal never animates, or all of them when it calls this without
        // animating. They start from as they were last animated instead.
        for (s.input[0..n], s.stale[0..n], sk.wrote, 0..) |*m, *stale, wrote, i| {
            const at = bones.data + i * stride;
            // Only bones posing's written lately can have its writes in
            const written = std.mem.indexOfNone(u64, &wrote, &.{0}) != null;
            stale.* = written and std.mem.indexOfScalar(u64, &wrote, boneHash(at, stride)) != null;
            if (stale.*) m.* = sk.base[i] else {
                m.* = layout.read(at);
                sk.base[i] = m.*;
            }
        }
        @memcpy(s.matrices[0..n], s.input[0..n]);
        self.service.pose(.{ .id = component, .name = sk.name, .bones = sk.bones, .to_world = mesh.to_world }, &s.matrices[0]);
        sk.edited = false;
        // Unreal passes arrays around, so a bone can have what posing wrote a few frames back
        sk.ring = (sk.ring + 1) % wrote_kept;
        for (s.matrices[0..n], s.input[0..n], s.stale[0..n], sk.wrote, 0..) |m, in, stale, *wrote, i| {
            const at = bones.data + i * stride;
            const changed = !m.approxEql(in, 1e-6);
            // A stale bone has an old edit in, which may be gone now
            if (changed or stale) layout.write(at, m);
            wrote[sk.ring] = if (changed) boneHash(at, stride) else 0;
            sk.edited = sk.edited or changed;
        }
        if (sk.shapes.len > 0) self.poseShapes(component, sk);
    }

    /// Hands posing the blend shapes as the animation has them, and puts posing's over them, or
    /// hands back the ones it's let go of.
    fn poseShapes(self: *Posing, component: usize, sk: *Skeleton) void {
        const m = &(self.morphs orelse return);
        const anim = self.ue.mem.live(usize, component + self.meshes.off.anim_instance);
        if (anim == 0) return;
        const s = self.scratch;
        const n = sk.shapes.len;
        for (sk.shapes, s.weights_in[0..n]) |sh, *w| w.* = m.weight(anim, sh.name);
        @memcpy(s.weights[0..n], s.weights_in[0..n]);
        self.service.shapes(component, sk.shape_list, &s.weights[0]);
        for (sk.shapes, s.weights[0..n], s.weights_in[0..n]) |*sh, w, in| m.set(sh, if (w != in) w else null);
    }

    /// Every blend shape back to the game's.
    fn unshapeAll(self: *Posing) void {
        const m = &(self.morphs orelse return);
        var it = self.skeletons.valueIterator();
        while (it.next()) |sk| for (sk.shapes) |*sh| {
            if (sh.set != null and self.ue.objects.isObject(sh.component)) m.set(sh, null);
        };
    }

    fn boneHash(at: usize, stride: usize) u64 {
        return std.hash.Wyhash.hash(0, @as([*]const u8, @ptrFromInt(at))[0..stride]);
    }

    /// Edited meshes back as the game last animated them, and held ones let go, as the plugin
    /// goes. Game thread only.
    pub fn restore(self: *Posing) void {
        const layout = self.meshes.bones.layout;
        var it = self.skeletons.iterator();
        while (it.next()) |kv| {
            const sk = kv.value_ptr;
            if (!sk.edited or !self.ue.objects.isObject(kv.key_ptr.*)) continue;
            sk.edited = false;
            const bones = self.meshes.bones.drawn(kv.key_ptr.*) orelse continue;
            if (bones.count != sk.total) continue;
            for (sk.base[0..sk.count], 0..) |m, i| layout.write(bones.data + i * layout.size(), m);
        }
        self.unshapeAll();
        self.release();
    }

    /// Its skeleton, built afresh if its bone count's changed.
    fn skeletonOf(self: *Posing, component: usize, count: u32) ?*Skeleton {
        const entry = self.skeletons.getOrPut(gpa, component) catch return null;
        if (entry.found_existing) {
            if (entry.value_ptr.total == count) return entry.value_ptr;
            entry.value_ptr.arena.deinit();
        }
        entry.value_ptr.* = self.build(component) catch {
            self.skeletons.removeByPtr(entry.key_ptr);
            return null;
        };
        return if (entry.value_ptr.total == count) entry.value_ptr else null;
    }

    /// Bone names and parents, from the component, and what it's called after its actor.
    fn build(self: *Posing, component: usize) !Skeleton {
        var arena: std.heap.ArenaAllocator = .init(gpa);
        errdefer arena.deinit();
        const a = arena.allocator();
        const total = self.meshes.numBones(component) orelse return error.NoBones;
        if (total < 3) return error.NoBones;
        const n: u32 = @min(total, max_bones);
        const fnames = try a.alloc(FName, n);
        const bones = try a.alloc(W.PosingBone, n);
        var buf: [256]u8 = undefined;
        // Parents come before children, so the first ones are a whole skeleton
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
        var shapes: std.ArrayList(morphs_.Shape) = .empty;
        var list: std.ArrayList(W.PosingShape) = .empty;
        if (self.morphs) |*m| {
            // A face is often its own mesh following the body
            var with: [16]usize = undefined;
            with[0] = component;
            var k: usize = 1;
            const index = self.ue.mem.read(u32, component + Unreal.object.index) orelse 0;
            for (self.followers.items) |f| {
                if (f.leader != index or k == with.len) continue;
                with[k] = f.component;
                k += 1;
            }
            m.collect(a, with[0..k], &shapes, &list) catch {};
        }
        return .{
            .total = total,
            .count = n,
            .name = try a.dupe(u8, self.ue.nameOf(owner, &buf) orelse "?"),
            .bones = bones,
            .base = try a.alloc(Mat4, n),
            .wrote = blk: {
                const w = try a.alloc([wrote_kept]u64, n);
                @memset(w, @splat(0));
                break :blk w;
            },
            .shapes = shapes.items,
            .shape_list = list.items,
            .arena = arena,
        };
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

    /// Holds the meshes being posed while posing's open, and lets them go as it closes, a few
    /// frames later in a paused world.
    fn holdWhileOpen(self: *Posing, paused: bool) void {
        if (self.active) {
            self.release_in = release_after;
            for (self.meshes.nearest()) |c| self.hold(c);
            if (paused) self.holdFollowers();
            for (self.held.items) |*h| {
                if (!self.ue.objects.isObjectPlain(h.component)) continue;
                if (paused) self.freeze(h) else self.thaw(h);
            }
            return;
        }
        if (self.held.items.len == 0) return;
        if (paused and self.release_in > 0) {
            self.release_in -= 1;
            return;
        }
        self.release();
    }

    /// Every bone, every frame. Games can change these back as they like, so it's every tick. Plain
    /// reads and writes, since it's every tick and the game was animating it a moment ago. Full
    /// detail costs the most, so only once the player's picked it or edited it.
    fn hold(self: *Posing, component: usize) void {
        if (!self.ue.objects.isObjectPlain(component)) return;
        const mem = self.ue.mem;
        const o = self.off;
        const h = for (self.held.items) |*h| {
            if (h.component == component) break h;
        } else blk: {
            if (self.held.items.len >= max_held) return;
            self.held.append(gpa, .{
                .component = component,
                .uro = if (o.uro) |b| mem.live(u8, component + b.offset) & b.mask != 0 else false,
                .interval = if (o.interval) |i| mem.live(f32, component + i) else 0,
                .lod = if (o.forced_lod_at) |l| mem.live(i32, component + l) else 0,
            }) catch return;
            break :blk &self.held.items[self.held.items.len - 1];
        };
        if (o.uro) |b| {
            const v = mem.live(u8, component + b.offset);
            if (v & b.mask != 0) mem.setLive(u8, component + b.offset, v & ~b.mask);
        }
        if (o.interval) |i| {
            if (mem.live(f32, component + i) != 0) mem.setLive(f32, component + i, 0);
        }
        if (!h.detailed) h.detailed = self.service.wanted(component);
        if (h.detailed) if (o.forced_lod_at) |l| {
            if (mem.live(i32, component + l) != 1) self.setInt(component, o.forced_lod, 1);
        };
    }

    /// Every mesh that copies its bones from another. One look through every object, so only as
    /// posing opens and as the world pauses, since nothing new comes along while it's paused.
    fn findFollowers(self: *Posing) void {
        self.followers.clearRetainingCapacity();
        const leader = self.off.leader orelse return;
        for (0..self.ue.objects.count()) |i| {
            const obj = self.ue.objects.getPlain(i);
            if (!self.ue.isLive(obj, self.off.skinned)) continue;
            // A weak pointer, its object's index then serial number
            const index = self.ue.mem.live(i32, obj + leader);
            if (index < 0) continue;
            self.followers.append(gpa, .{ .leader = @intCast(index), .component = obj }) catch return;
        }
    }

    /// Meshes that copy their bones from a held one. They only take them as they tick, which a
    /// paused world doesn't do.
    fn holdFollowers(self: *Posing) void {
        if (self.followers.items.len == 0) return;
        var leaders: [max_held]u32 = undefined;
        var n: usize = 0;
        for (self.held.items) |h| {
            if (h.follower or !self.ue.objects.isObjectPlain(h.component)) continue;
            leaders[n] = self.ue.mem.live(u32, h.component + Unreal.object.index);
            n += 1;
        }
        for (self.followers.items) |f| {
            if (self.held.items.len >= max_held) return;
            if (std.mem.indexOfScalar(u32, leaders[0..n], f.leader) == null) continue;
            const known = for (self.held.items) |h| {
                if (h.component == f.component) break true;
            } else false;
            if (!known and self.ue.objects.isObjectPlain(f.component)) self.held.append(gpa, .{ .component = f.component, .follower = true }) catch return;
        }
    }

    fn freeze(self: *Posing, h: *Held) void {
        if (h.frozen != null) return;
        const rate_at = self.off.rate orelse return;
        const mem = self.ue.mem;
        const rate = if (h.follower) 0 else mem.live(f32, h.component + rate_at);
        const tickable = if (self.off.tickable_bit) |b| mem.live(u8, h.component + b.offset) & b.mask != 0 else false;
        h.frozen = .{ .rate = rate, .tickable = tickable };
        if (!h.follower) mem.setLive(f32, h.component + rate_at, 0);
        if (!tickable) self.setBool(h.component, self.off.tickable, true);
    }

    fn thaw(self: *Posing, h: *Held) void {
        const fr = h.frozen orelse return;
        h.frozen = null;
        if (!h.follower) self.ue.mem.setLive(f32, h.component + self.off.rate.?, fr.rate);
        if (!fr.tickable) self.setBool(h.component, self.off.tickable, false);
    }

    /// Puts held meshes back how they were.
    fn release(self: *Posing) void {
        const mem = self.ue.mem;
        const o = self.off;
        for (self.held.items) |*h| {
            if (!self.ue.objects.isObjectPlain(h.component)) continue;
            self.thaw(h);
            if (h.follower) continue;
            if (o.uro) |b| {
                const v = mem.live(u8, h.component + b.offset);
                mem.setLive(u8, h.component + b.offset, if (h.uro) v | b.mask else v & ~b.mask);
            }
            if (o.interval) |i| mem.setLive(f32, h.component + i, h.interval);
            if (h.detailed and o.forced_lod_at != null) self.setInt(h.component, o.forced_lod, h.lod);
        }
        self.held.clearRetainingCapacity();
    }

    fn setBool(self: *Posing, component: usize, call: ?Unreal.Call, on: bool) void {
        const c = call orelse return;
        var p: [16]u8 align(16) = @splat(0);
        if (c.size > p.len) return;
        p[c.params[0]] = @intFromBool(on);
        self.loop.call(component, c.function, p[0..c.size]);
    }

    fn setInt(self: *Posing, component: usize, call: ?Unreal.Call, v: i32) void {
        const c = call orelse return;
        var p: [16]u8 align(16) = @splat(0);
        if (c.size > p.len) return;
        std.mem.writeInt(i32, p[c.params[0]..][0..4], v, .little);
        self.loop.call(component, c.function, p[0..c.size]);
    }
};
