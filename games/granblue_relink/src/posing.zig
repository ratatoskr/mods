//! Posing, applied to each model's joints just while it's skinned.
//! Faces, hair and weapons are separate models, posed as part of their body's skeleton.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const schema = @import("schema").GranblueRelink;

const Model = schema.Model;
const Node = schema.Node;
const JointNumber = schema.JointNumber;
const Mat4 = sdk.math.Mat4;
const Skin = Model.Fns.skin;
const SkinHook = sdk.hooks.FnHook(Skin);
const clock = @import("clock.zig");

const max_joints = 1024;
/// A body and its parts together.
const max_character = 2048;
const max_models = 2048;
const max_changes = 32768;
const numbers = 0x1000;
const no_joint = 0xFFF;
const no_branch = 0xFFFF;
const copy_tolerance = 1e-3;
const moved_tolerance = 1e-5;
/// Frames a model counts as around after it was last skinned.
const recent = 3;
const searches_per_frame = 4;
/// Frames before looking again for a model's body.
const search_again = 120;

comptime {
    std.debug.assert(@sizeOf(Node) == 0x110);
}

/// A model seen while posing's open.
const Known = struct {
    model: usize = 0,
    seen: u32 = 0,
    joints: usize = 0,
    /// The body it's part of, or 0.
    parent: usize = 0,
    /// The body's joint it hangs off, by number.
    at: u16 = 0,
    /// Sits on that joint, like a weapon, rather than copying the body's joints.
    whole: bool = false,
    next_search: u32 = 0,
    /// Its slice of `changes`, empty till it has one.
    first_change: usize = 0,
    change_count: usize = 0,
};

pub const Posing = struct {
    service: W.Posing = undefined,
    skin: SkinHook = undefined,
    /// Models skin on worker threads.
    lock: sdk.sync.Mutex = .{},

    // One model's joints, by the game's index
    parent_of: [max_joints]i32 = undefined,
    placed: [max_joints]bool = undefined,
    /// Parents first.
    order: [max_joints]u16 = undefined,
    in_character: [max_joints]u32 = undefined,
    /// `in_character` for the body, which walking its parts overwrites.
    body_place: [max_joints]u32 = undefined,
    saved: [max_joints]Mat4 = undefined,

    // The character's skeleton, parents first
    bones: [max_character]W.Posing.Bone = undefined,
    names: [max_character][20]u8 = undefined,
    own: [max_character]Mat4 = undefined,
    posed: [max_character]Mat4 = undefined,
    by_number: [numbers]i32 = @splat(-1),
    /// Slots in `known` of the body's parts.
    members: [max_character]u32 = undefined,

    known: [max_models]Known = undefined,
    known_len: usize = 0,
    changes: [max_changes]Mat4 = undefined,
    /// Each change's joint in the body's skeleton.
    places: [max_changes]u32 = undefined,
    changes_len: usize = 0,
    searches: u32 = 0,
    search_frame: u32 = 0,
    /// Skins left to rebuild after posing closes, so a paused game drops the pose.
    linger: sdk.atomic.Value(u32) = .init(0),

    pub fn start(self: *Posing) !void {
        self.service = (sdk.wraith.root() orelse return error.PosingMissing).posing();
        self.skin = try sdk.hooks.createFnWith(Skin, try Model.addresses.skin(), skinDetour, self, .{ .enabled = true });
    }

    fn skinDetour(self: *Posing, hook: SkinHook, model: *Model, frame: u32) void {
        if (!self.service.active()) {
            if (self.linger.load(.monotonic) > 0) {
                model.skin_dirty = true;
                if (self.linger.fetchSub(1, .monotonic) == 1) self.forget();
            }
            return hook.original()(model, frame);
        }
        self.linger.store(4096, .monotonic);
        self.lock.lock() catch return hook.original()(model, frame);
        defer self.lock.unlock();
        const count = model.joint_count;
        if (count == 0 or count > max_joints or model.joints == 0) return hook.original()(model, frame);
        const now = clock.frame.load(.monotonic);
        const known = self.know(@intFromPtr(model), now, count) orelse return hook.original()(model, frame);
        if (now != self.search_frame) {
            self.search_frame = now;
            self.searches = 0;
        }
        self.placeOn(known, now);

        if (known.parent != 0) return self.skinMember(hook, model, frame, known);
        self.skinCharacter(hook, model, frame, now);
    }

    /// A body's part, with what posing did to it there.
    fn skinMember(self: *Posing, hook: SkinHook, model: *Model, frame: u32, known: *Known) void {
        const count = model.joint_count;
        if (known.change_count != count) return hook.original()(model, frame);
        const joints: [*]Node = @ptrFromInt(model.joints);
        for (0..count) |j| {
            self.saved[j] = joints[j].world;
            const change = self.changes[known.first_change + j];
            if (!change.approxEql(.identity, moved_tolerance)) joints[j].world = self.saved[j].mul(change);
        }
        model.skin_dirty = true;
        hook.original()(model, frame);
        for (0..count) |j| joints[j].world = self.saved[j];
    }

    /// A body, posed with its parts.
    fn skinCharacter(self: *Posing, hook: SkinHook, model: *Model, frame: u32, now: u32) void {
        const id = @intFromPtr(model);
        const joints: [*]Node = @ptrFromInt(model.joints);
        const count = self.walk(joints, model.joint_count);
        var n: usize = 0;
        for (self.order[0..count]) |j| {
            const parent = self.parent_of[j];
            const number = numberOf(&joints[j]);
            self.body_place[j] = @intCast(n);
            self.add(&n, "", number, joints[j].world, if (parent >= 0) @intCast(self.body_place[@intCast(parent)]) else -1);
            self.by_number[number] = @intCast(n - 1);
        }

        var member_count: usize = 0;
        for (self.known[0..self.known_len], 0..) |*k, slot| {
            if (k.parent != id or !isRecent(k.seen, now) or member_count == self.members.len) continue;
            const before = n;
            if (!self.addMember(k, &n)) {
                n = before;
                continue;
            }
            self.members[member_count] = @intCast(slot);
            member_count += 1;
        }

        @memcpy(self.posed[0..n], self.own[0..n]);
        var label: [32]u8 = undefined;
        const name = objectName(&label, model);
        self.service.pose(.{ .id = id, .name = name, .bones = self.bones[0..n], .to_world = .identity }, &self.posed[0]);

        for (self.members[0..member_count]) |slot| self.keepChanges(&self.known[slot]);
        for (0..count) |j| self.by_number[numberOf(&joints[j])] = -1;

        for (0..count) |j| {
            self.saved[j] = joints[j].world;
            joints[j].world = self.posed[self.body_place[j]];
        }
        // So it shows on a paused game too
        model.skin_dirty = true;
        hook.original()(model, frame);
        for (0..count) |j| joints[j].world = self.saved[j];
    }

    /// Adds a part's joints, its copies of the body's as the body's own. False if there's no room.
    fn addMember(self: *Posing, known: *Known, n: *usize) bool {
        const model: *Model = @ptrFromInt(known.model);
        const joints: [*]Node = @ptrFromInt(model.joints);
        const count = self.walk(joints, model.joint_count);
        if (n.* + count > max_character) return false;
        const on = self.by_number[known.at];
        // Two of the same, like weapons, stay apart by where they hang
        var label: [16]u8 = undefined;
        var prefix: [24]u8 = undefined;
        const tag = std.fmt.bufPrint(&prefix, "{s}@{x:0>3}/", .{ objectName(&label, model), known.at }) catch "";
        for (self.order[0..count]) |j| {
            const number = numberOf(&joints[j]);
            const world = joints[j].world;
            const body = self.by_number[number];
            if (body >= 0 and self.own[@intCast(body)].approxEql(world, copy_tolerance)) {
                self.in_character[j] = @intCast(body);
                continue;
            }
            const parent = self.parent_of[j];
            const above: i32 = if (parent >= 0) @intCast(self.in_character[@intCast(parent)]) else on;
            self.in_character[j] = @intCast(n.*);
            self.add(n, tag, number, world, above);
        }
        // Same slot each frame, so a part skinned before its body still has last frame's
        if (known.change_count != count) {
            if (self.changes_len + count > max_changes) {
                for (self.known[0..self.known_len]) |*k| k.change_count = 0;
                self.changes_len = 0;
            }
            known.first_change = self.changes_len;
            known.change_count = count;
            self.changes_len += count;
        }
        @memcpy(self.places[known.first_change..][0..count], self.in_character[0..count]);
        return true;
    }

    /// What posing did to a part's joints, for when it's skinned.
    fn keepChanges(self: *Posing, known: *Known) void {
        const model: *Model = @ptrFromInt(known.model);
        const joints: [*]Node = @ptrFromInt(model.joints);
        for (0..model.joint_count) |j| {
            const at = self.places[known.first_change + j];
            const back = joints[j].world.inverse() orelse Mat4.identity;
            self.changes[known.first_change + j] = back.mul(self.posed[at]);
        }
    }

    fn add(self: *Posing, n: *usize, tag: []const u8, number: u16, world: Mat4, parent: i32) void {
        const k = n.*;
        const name = std.fmt.bufPrint(&self.names[k], "{s}_{x:0>3}", .{ tag, number }) catch "?";
        self.bones[k] = .{ .name = name, .parent = parent };
        self.own[k] = world;
        n.* = k + 1;
    }

    /// Finds, or checks again, a model's body.
    fn placeOn(self: *Posing, known: *Known, frame: u32) void {
        if (known.parent != 0) {
            if (self.stillOn(known, frame)) return;
            known.parent = 0;
            known.next_search = frame;
        }
        if (@as(i32, @bitCast(frame -% known.next_search)) < 0 or self.searches >= searches_per_frame) return;
        self.searches += 1;
        known.next_search = frame +% search_again;
        self.search(known, frame);
    }

    fn stillOn(self: *Posing, known: *const Known, frame: u32) bool {
        const parent = self.find(known.parent) orelse return false;
        if (!isRecent(parent.seen, frame) or parent.parent != 0) return false;
        const model: *Model = @ptrFromInt(known.model);
        const body: *Model = @ptrFromInt(known.parent);
        const there = jointOf(body, known.at) orelse return false;
        const here = if (known.whole) model.root.world else (jointOf(model, known.at) orelse return false).world;
        return there.world.approxEql(here, copy_tolerance);
    }

    /// A bigger model its root joints are copied from, or else one it sits on.
    fn search(self: *Posing, known: *Known, frame: u32) void {
        const model: *Model = @ptrFromInt(known.model);
        const joints: [*]Node = @ptrFromInt(model.joints);
        const first_joint = model.joints;
        const end = first_joint + model.joint_count * @sizeOf(Node);
        for (self.known[0..self.known_len]) |*other| {
            if (!couldHold(other, known, frame)) continue;
            const body: *Model = @ptrFromInt(other.model);
            for (0..model.joint_count) |j| {
                const p = @intFromPtr(joints[j].parent);
                if (p >= first_joint and p < end) continue;
                const number = numberOf(&joints[j]);
                const there = jointOf(body, number) orelse continue;
                if (!there.world.approxEql(joints[j].world, copy_tolerance)) continue;
                known.* = .{ .model = known.model, .seen = known.seen, .joints = known.joints, .parent = other.model, .at = number, .whole = false };
                return;
            }
        }
        for (self.known[0..self.known_len]) |*other| {
            if (!couldHold(other, known, frame)) continue;
            const body: *Model = @ptrFromInt(other.model);
            const body_joints: [*]Node = @ptrFromInt(body.joints);
            for (0..body.joint_count) |j| {
                if (!body_joints[j].world.approxEql(model.root.world, copy_tolerance)) continue;
                known.* = .{ .model = known.model, .seen = known.seen, .joints = known.joints, .parent = other.model, .at = numberOf(&body_joints[j]), .whole = true };
                return;
            }
        }
    }

    fn know(self: *Posing, model: usize, frame: u32, joints: usize) ?*Known {
        const k = self.find(model) orelse blk: {
            for (self.known[0..self.known_len]) |*e| if (frame -% e.seen > search_again) {
                e.* = .{ .model = model, .next_search = frame };
                break :blk e;
            };
            if (self.known_len == max_models) return null;
            self.known[self.known_len] = .{ .model = model, .next_search = frame };
            self.known_len += 1;
            break :blk &self.known[self.known_len - 1];
        };
        k.seen = frame;
        k.joints = joints;
        return k;
    }

    fn find(self: *Posing, model: usize) ?*Known {
        for (self.known[0..self.known_len]) |*e| if (e.model == model) return e;
        return null;
    }

    fn forget(self: *Posing) void {
        self.lock.lock() catch return;
        defer self.lock.unlock();
        self.known_len = 0;
        self.changes_len = 0;
    }

    /// Orders `joints` parents first into `order`, with `parent_of`.
    fn walk(self: *Posing, joints: [*]Node, count: usize) usize {
        const first_joint = @intFromPtr(joints);
        const end = first_joint + count * @sizeOf(Node);
        for (0..count) |i| {
            // Roots point at the model's root, which isn't a joint
            const p = @intFromPtr(joints[i].parent);
            const inside = p >= first_joint and p < end and (p - first_joint) % @sizeOf(Node) == 0;
            const parent = if (inside) (p - first_joint) / @sizeOf(Node) else i;
            self.parent_of[i] = if (parent != i) @intCast(parent) else -1;
        }

        // The game's mostly parents first already, so this takes a pass or two
        @memset(self.placed[0..count], false);
        var n: usize = 0;
        while (n < count) {
            const before = n;
            for (0..count) |i| {
                if (self.placed[i]) continue;
                const parent = self.parent_of[i];
                if (parent >= 0 and !self.placed[@intCast(parent)]) continue;
                self.placed[i] = true;
                self.order[n] = @intCast(i);
                n += 1;
            }
            // Anything left is in a loop
            if (n == before) for (0..count) |i| if (!self.placed[i]) {
                self.parent_of[i] = -1;
                self.placed[i] = true;
                self.order[n] = @intCast(i);
                n += 1;
                break;
            };
        }
        return n;
    }
};

/// Like pl0300, or the address for models without one.
fn objectName(buf: []u8, model: *const Model) []const u8 {
    const id = model.object;
    const prefix: ?[]const u8 = switch (id >> 16) {
        0x1 => "pl",
        0x2 => "em",
        0x3 => "wp",
        0x4 => "et",
        0x5 => "ef",
        0x7 => "it",
        0x9 => "sc",
        0xC => "bg",
        0xE => "bh",
        0xF => "ba",
        0x100 => "fp",
        0x101 => "fe",
        0x102 => "fn",
        0x103 => "we",
        0x104 => "wn",
        0x10A => "np",
        0x10B => "tr",
        0x10C => "bt",
        0x10D => "so",
        else => null,
    };
    if (prefix) |p| return std.fmt.bufPrint(buf, "{s}{x:0>4}", .{ p, id & 0xFFFF }) catch "?";
    return std.fmt.bufPrint(buf, "{x}", .{@intFromPtr(model) & 0xFFFFFF}) catch "?";
}

fn numberOf(node: *const Node) u16 {
    const n = node.number;
    return (@as(u16, n.high) << 8) | (@as(u16, n.middle) << 4) | n.low;
}

fn jointOf(model: *Model, number: u16) ?*Node {
    const skeleton = model.skeleton orelse return null;
    const first = skeleton.lookup orelse return null;
    if (model.joints == 0) return null;
    const table: [*]const u16 = @ptrCast(first);
    const key: JointNumber = @bitCast(number);
    const second = table[key.high];
    if (second == no_branch) return null;
    const third = table[second + key.middle];
    if (third == no_branch) return null;
    const index = table[third + key.low];
    if (index == no_joint or index >= model.joint_count) return null;
    const joints: [*]Node = @ptrFromInt(model.joints);
    return &joints[index];
}

fn couldHold(other: *const Known, known: *const Known, frame: u32) bool {
    return other.model != known.model and other.parent == 0 and other.joints > known.joints and isRecent(other.seen, frame);
}

fn isRecent(seen: u32, frame: u32) bool {
    return frame -% seen <= recent;
}
