//! Hands each character's skeleton to posing, once the game's animated it and run its IK, but
//! before the accessories attached to it are placed.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const schema = @import("schema").TrailsHorizon;
const common = @import("tweaks/common.zig");

const Chara = schema.Chara;
const ModelInstance = schema.ModelInstance;
const DagNode = schema.DagNode;
const Mat4 = sdk.math.Mat4;
const Update = Chara.Fns.onModelUpdate;
const UpdateHook = sdk.hooks.FnHook(Update);
const Modifiers = ModelInstance.Fns.updateModifiers;
const ModifiersHook = sdk.hooks.FnHook(Modifiers);

/// Kai's models have a couple of hundred nodes, so they fit on the stack, and bigger ones go on the heap.
const stack_bytes = 64 * 1024;
const gpa = std.heap.smp_allocator;

/// The character whose model this thread is updating. Charas update on worker threads, and the
/// model runs its modifiers straight after the character's callback.
threadlocal var updating: ?*Chara = null;

pub const Posing = struct {
    service: W.Posing = undefined,
    update: UpdateHook = undefined,
    modifiers: ModifiersHook = undefined,

    pub fn start(self: *Posing) !void {
        self.service = (sdk.wraith.root() orelse return error.PosingMissing).posing();
        self.update = try sdk.hooks.createFnWith(Update, try Chara.addresses.onModelUpdate(), onModelUpdate, self, .{ .enabled = true });
        self.modifiers = try sdk.hooks.createFnWith(Modifiers, try ModelInstance.addresses.updateModifiers(), updateModifiers, self, .{ .enabled = true });
    }

    fn onModelUpdate(_: *Posing, hook: UpdateHook, chara: *Chara, dt: f32) void {
        updating = chara;
        hook.original()(chara, dt);
    }

    /// After IK and dynamic bones, so they don't undo the pose, and before attached models follow it.
    fn updateModifiers(self: *Posing, hook: ModifiersHook, model: *ModelInstance, dt: f32, context: usize, step: ?*f32) void {
        hook.original()(model, dt, context, step);
        const chara = updating orelse return;
        updating = null;
        if (chara.model != model) return;
        self.pose(chara);
    }

    fn pose(self: *Posing, chara: *Chara) void {
        if (!self.service.active()) return;
        const root = (chara.model orelse return).root orelse return;

        // Worker threads pose at once, so each call has its own
        var stack: [stack_bytes]u8 align(16) = undefined;
        var first: std.heap.BufferFirstAllocator = .init(&stack, gpa);
        const a = first.allocator();
        var tree: Tree = .{};
        defer tree.deinit(a);
        tree.walk(a, root) catch return;
        const nodes = tree.nodes.items;
        const bones = tree.bones.items;
        const count = nodes.len;
        const matrices = a.alloc(Mat4, count) catch return;
        defer a.free(matrices);
        const unnamed = a.alloc([10]u8, count) catch return;
        defer a.free(unnamed);
        for (nodes, bones, unnamed, matrices) |n, *b, *buf, *m| {
            // Edits go by name, so ones without get their hash
            if (b.name.len == 0) b.name = std.fmt.bufPrint(buf, "#{x:0>8}", .{n.name_hash}) catch unreachable;
            m.* = n.world;
        }

        var label: [48]u8 = undefined;
        const own = std.mem.sliceTo(&chara.name, 0);
        const name = common.nameOf(chara.chrid) orelse if (own.len > 0) own else std.fmt.bufPrint(&label, "{d}", .{chara.chrid}) catch "?";
        self.service.pose(.{ .id = @intFromPtr(chara), .name = name, .bones = bones, .to_world = .identity }, &matrices[0]);
        for (nodes, matrices) |n, m| n.world = m;
    }
};

/// A model's nodes, parents before their children, and each as a bone.
const Tree = struct {
    nodes: std.ArrayList(*DagNode) = .empty,
    bones: std.ArrayList(W.Posing.Bone) = .empty,

    fn deinit(t: *Tree, a: std.mem.Allocator) void {
        t.bones.deinit(a);
        t.nodes.deinit(a);
    }

    /// The tree under `root` depth first, so parents come before their children.
    fn walk(t: *Tree, a: std.mem.Allocator, root: *DagNode) !void {
        const Next = struct { node: *DagNode, parent: i32 };
        var stack: std.ArrayList(Next) = .empty;
        defer stack.deinit(a);
        try stack.append(a, .{ .node = root, .parent = -1 });
        while (stack.pop()) |at| {
            const i = t.nodes.items.len;
            try t.nodes.append(a, at.node);
            try t.bones.append(a, .{ .name = std.mem.sliceTo(&at.node.name, 0), .parent = at.parent });
            // Siblings go on first so the children come straight after their parent
            if (at.node != root) if (at.node.sibling) |s| try stack.append(a, .{ .node = s, .parent = at.parent });
            if (at.node.child) |c| try stack.append(a, .{ .node = c, .parent = @intCast(i) });
        }
    }
};
