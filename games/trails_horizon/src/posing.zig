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

/// Kai's models have a couple of hundred nodes, so this leaves plenty of room.
const max_nodes = 512;

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

        var nodes: [max_nodes]*DagNode = undefined;
        var bones: [max_nodes]W.Posing.Bone = undefined;
        var matrices: [max_nodes]Mat4 = undefined;
        var unnamed: [max_nodes][10]u8 = undefined;
        const count = walk(root, &nodes, &bones);
        for (nodes[0..count], bones[0..count], unnamed[0..count], matrices[0..count]) |n, *b, *buf, *m| {
            // Edits go by name, so ones without get their hash
            if (b.name.len == 0) b.name = std.fmt.bufPrint(buf, "#{x:0>8}", .{n.name_hash}) catch unreachable;
            m.* = n.world;
        }

        var label: [48]u8 = undefined;
        const own = std.mem.sliceTo(&chara.name, 0);
        const name = common.nameOf(chara.chrid) orelse if (own.len > 0) own else std.fmt.bufPrint(&label, "{d}", .{chara.chrid}) catch "?";
        self.service.pose(.{ .id = @intFromPtr(chara), .name = name, .bones = bones[0..count], .to_world = .identity }, &matrices[0]);
        for (nodes[0..count], matrices[0..count]) |n, m| n.world = m;
    }
};

/// The tree under `root` depth first, so parents come before their children. Gives how many.
fn walk(root: *DagNode, nodes: *[max_nodes]*DagNode, bones: *[max_nodes]W.Posing.Bone) usize {
    const Next = struct { node: *DagNode, parent: i32 };
    var stack: [max_nodes]Next = undefined;
    stack[0] = .{ .node = root, .parent = -1 };
    var top: usize = 1;
    var count: usize = 0;
    while (top > 0 and count < max_nodes) {
        top -= 1;
        const at = stack[top];
        const i = count;
        nodes[i] = at.node;
        bones[i] = .{ .name = std.mem.sliceTo(&at.node.name, 0), .parent = at.parent };
        count += 1;
        // Siblings go on first so the children come straight after their parent
        if (at.node != root) if (at.node.sibling) |s| if (top < stack.len) {
            stack[top] = .{ .node = s, .parent = at.parent };
            top += 1;
        };
        if (at.node.child) |c| if (top < stack.len) {
            stack[top] = .{ .node = c, .parent = @intCast(i) };
            top += 1;
        };
    }
    return count;
}
