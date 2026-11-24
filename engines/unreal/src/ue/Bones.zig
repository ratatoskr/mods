//! Where a skinned mesh's bones are as it's drawn. They're its component-space transforms,
//! `ComponentSpaceTransformsArray[2]`, which aren't reflected, so where they are is learned once by
//! watching the nearest animated meshes: the two arrays of the bone count, then which of them is
//! drawn, then whether the game flips them after an anim instance's post-evaluate or before it, as
//! 4.18 does. Some meshes only ever have the one array, even in games that double them.

const std = @import("std");
const sdk = @import("wraith_sdk");

const Unreal = @import("Unreal.zig");

const Vec3 = sdk.math.Vec3;
const Mat4 = sdk.math.Mat4;
const log = sdk.log.scoped(.unreal);

/// Faces bring big skeletons.
pub const max_total = 4096;
/// Frames of animated meshes with no second array among them before it's taken there's only one.
const single_after = 120;
const flip_votes = 16;

/// An FTransform, as floats before UE5 and doubles after.
pub const Layout = struct {
    doubles: bool,

    pub fn size(self: Layout) usize {
        return if (self.doubles) 0x60 else 0x30;
    }

    pub fn read(self: Layout, at: usize) Mat4 {
        var v: [12]f32 = undefined;
        if (self.doubles) {
            const d: *align(1) const [12]f64 = @ptrFromInt(at);
            for (&v, d) |*o, x| o.* = @floatCast(x);
        } else v = @as(*align(1) const [12]f32, @ptrFromInt(at)).*;
        return .transform(.{ .x = v[4], .y = v[5], .z = v[6] }, .{ .x = v[0], .y = v[1], .z = v[2], .w = v[3] }, .{ .x = v[8], .y = v[9], .z = v[10] });
    }

    pub fn write(self: Layout, at: usize, m: Mat4) void {
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

/// A mesh's bones, read afresh each time, since Unreal swaps whole arrays around.
pub const Array = struct { data: usize, count: u32 };

/// What follows the bone arrays, watched over frames for the buffer indexes: always one 0 and one
/// 1, swapping as it's animated. Where they are moves between versions, and other fields nearby
/// hold 0s and 1s that don't.
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

pub const Bones = struct {
    ue: *const Unreal,
    layout: Layout,
    /// `USkinnedMeshComponent`'s own fields, between its parent's size and its own.
    from: usize,
    to: usize,
    /// Where the two arrays are.
    arrays: ?usize = null,
    /// `CurrentReadComponentTransforms`, with the editable index just before it.
    read_index: ?usize = null,
    /// No mesh's had a second array, so there's only the one.
    single: bool = false,
    flips_after: ?bool = null,
    // Learning, from one mesh with both arrays
    probe: Probe = .{},
    watching: usize = 0,
    watching_animated: bool = false,
    read_then: i32 = -1,
    votes: [2]u32 = .{ 0, 0 },
    single_frames: u32 = 0,

    pub fn ready(self: *const Bones) bool {
        return self.arrays != null and (self.single or self.flips_after != null);
    }

    /// Game thread, as a mesh's been animated, at its anim instance's post-evaluate.
    pub fn animated(self: *Bones, component: usize) void {
        if (self.ready() or component != self.watching) return;
        self.watching_animated = true;
        if (self.read_index) |r| self.read_then = self.ue.mem.read(i32, component + r) orelse -1;
    }

    /// Game thread, once a frame after every mesh's been animated. Learns a bit more from the
    /// nearest animated meshes, given how many bones the first has.
    pub fn learn(self: *Bones, nearest: []const usize, first_count: ?u32) void {
        if (self.ready() or nearest.len == 0) return;
        const arrays = self.arrays orelse {
            self.arrays = self.findArrays(nearest[0], first_count orelse return);
            return;
        };
        if (self.watching == 0 or !self.ue.objects.isObject(self.watching) or !self.doubled(self.watching)) {
            self.watching = for (nearest) |c| {
                if (self.doubled(c)) break c;
            } else 0;
            self.probe = .{};
            self.watching_animated = false;
            if (self.watching != 0) return;
            self.single_frames += 1;
            if (self.single_frames < single_after) return;
            self.single = true;
            log.info("Posing reads bones at +0x{x} in skinned meshes, a single buffer", .{arrays});
            return;
        }
        self.single_frames = 0;
        if (!self.watching_animated) return;
        self.watching_animated = false;
        const r = self.read_index orelse {
            const values = self.ue.mem.read([Probe.slots]i32, self.watching + arrays + 32) orelse return;
            self.probe.add(values);
            if (self.probe.samples < Probe.enough) return;
            // Not animated every frame, maybe, so it's another go
            const k = self.probe.pick() orelse {
                self.probe = .{};
                return;
            };
            self.read_index = arrays + 32 + (k + 1) * 4;
            log.info("Posing reads bones at +0x{x} in skinned meshes, drawn as +0x{x} says", .{ arrays, self.read_index.? });
            return;
        };
        const then = self.read_then;
        self.read_then = -1;
        if (then < 0) return;
        const now = self.ue.mem.read(i32, self.watching + r) orelse return;
        self.votes[@intFromBool(now != then)] += 1;
        const after, const before = .{ self.votes[1], self.votes[0] };
        if (after + before < flip_votes) return;
        self.flips_after = after > before;
        log.info("Posing edits bones as they're animated, {s} the game flips them", .{if (after > before) "before" else "after"});
    }

    /// What the game's just animated a mesh's bones into, at its post-evaluate, which is what's
    /// drawn once it's flipped them. Game thread, with the mesh live.
    pub fn justAnimated(self: *const Bones, component: usize) ?Array {
        return self.array(component, self.flips_after == true);
    }

    /// What's drawn. Game thread, with the mesh live.
    pub fn drawn(self: *const Bones, component: usize) ?Array {
        return self.array(component, false);
    }

    fn array(self: *const Bones, component: usize, editable: bool) ?Array {
        const mem = self.ue.mem;
        const arrays = self.arrays orelse return null;
        const h = mem.live([2][2]usize, component + arrays);
        const which: usize = if (self.read_index) |r| blk: {
            if (!isDoubled(h)) break :blk 0;
            break :blk if (mem.live(i32, component + if (editable) r - 4 else r) == 1) 1 else 0;
        } else 0;
        const count: u32 = @truncate(@as(u64, h[which][1]));
        if (h[which][0] == 0 or count == 0 or count > max_total) return null;
        return .{ .data = h[which][0], .count = count };
    }

    /// Has a second array as full as its first. Checked, for meshes that may be gone.
    fn doubled(self: *const Bones, component: usize) bool {
        const arrays = self.arrays orelse return false;
        return isDoubled(self.ue.mem.read([2][2]usize, component + arrays) orelse return false);
    }

    fn isDoubled(h: [2][2]usize) bool {
        const first: u32 = @truncate(@as(u64, h[0][1]));
        const second: u32 = @truncate(@as(u64, h[1][1]));
        return first != 0 and second == first and h[1][0] != 0;
    }

    /// Two `TArray<FTransform>`s of the bone count, or the second empty.
    fn findArrays(self: *const Bones, component: usize, n: u32) ?usize {
        const mem = self.ue.mem;
        var o = std.mem.alignForward(usize, self.from, 8);
        while (o + 64 <= self.to) : (o += 8) {
            const a = mem.read([2]usize, component + o) orelse continue;
            if (!countIs(a[1], n, false)) continue;
            const b = mem.read([2]usize, component + o + 16) orelse continue;
            if (!countIs(b[1], n, true)) continue;
            if (!self.layout.plausible(mem, a[0])) continue;
            return o;
        }
        log.warn("Can't find where skinned meshes keep their bones, so there's no posing", .{});
        return null;
    }
};

fn countIs(word: usize, n: u32, or_empty: bool) bool {
    const w: u64 = word;
    const num: u32 = @truncate(w);
    const max: u32 = @truncate(w >> 32);
    if (or_empty and num == 0) return true;
    return num == n and max >= n;
}

const testing = std.testing;
const Quat = sdk.math.Quat;

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
    try testing.expect(countIs((@as(usize, 70) << 32) | 70, 70, false));
    try testing.expect(!countIs((@as(usize, 69) << 32) | 70, 70, false));
    try testing.expect(countIs(0, 70, true));
    try testing.expect(!countIs(0, 70, false));
}
