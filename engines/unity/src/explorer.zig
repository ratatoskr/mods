//! The Workbench's Scene panel: the game's GameObjects as a tree, and the picked one's Transform and
//! components with their C# fields, which can be changed. Everything Unity's asked happens in a tick
//! on Unity's main thread, and only while the panel's open. The panel draws on the Workbench's own
//! thread from what the tick last published, and its changes go back through a queue the tick works
//! through. The tree's walked a slice a tick, so a big scene never holds up a frame for long.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema").Unity;

const engine_ = @import("engine.zig");
const Engine = engine_.Engine;
const Object = engine_.Object;
const Scene = @import("scene.zig").Scene;
const Local = @import("posing.zig").Local;

const ui = sdk.ui;
const W = sdk.api.wraith;
const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;
const Mat4 = sdk.math.Mat4;
const local = sdk.mem.Memory.local;
const gpa = std.heap.smp_allocator;
const log = sdk.log.scoped(.unity);
const word = @sizeOf(usize);
const array_length = 3 * word;
const array_items = 4 * word;

/// Asked again this often while it's open
const tree_every_ns = 2 * std.time.ns_per_s;
const details_every_ns = 200 * std.time.ns_per_ms;
/// How long a tick can spend walking the tree
const walk_budget_ns = std.time.ns_per_ms;
/// Most it shows
const max_nodes = 100_000;
const max_components = 64;
const max_fields = 128;
/// Field types looked up a refresh, since each asks the game's runtime
const max_new_types = 16;
/// Most a filter lists
const max_matches = 500;

/// Unity's engine calls for it, found like `Engine`'s.
const Calls = struct {
    find_objects: *const fn (?*Object, bool) callconv(.c) ?*Object,
    parent: *const fn (*Object) callconv(.c) ?*Object,
    child_count: *const fn (*Object) callconv(.c) i32,
    child: *const fn (*Object, i32) callconv(.c) ?*Object,
    sibling_index: *const fn (*Object) callconv(.c) i32,
    game_object: *const fn (*Object) callconv(.c) ?*Object,
    active_self: *const fn (*Object) callconv(.c) bool,
    active_in_hierarchy: *const fn (*Object) callconv(.c) bool,
    set_active: *const fn (*Object, bool) callconv(.c) void,
    /// `GetComponentsInternal(type, useSearchTypeAsArrayReturnType, recursive, includeInactive, reverse, resultList)`
    components: *const fn (*Object, ?*Object, bool, bool, bool, bool, ?*Object) callconv(.c) ?*Object,
    get_local_position: *const fn (*Object, *Vec3) callconv(.c) void,
    set_local_position: *const fn (*Object, *const Vec3) callconv(.c) void,
    get_local_rotation: *const fn (*Object, *Quat) callconv(.c) void,
    set_local_rotation: *const fn (*Object, *const Quat) callconv(.c) void,
    get_local_scale: *const fn (*Object, *Vec3) callconv(.c) void,
    set_local_scale: *const fn (*Object, *const Vec3) callconv(.c) void,

    const names = .{
        .find_objects = .{ "UnityEngine.Object", "FindObjectsOfType" },
        .parent = .{ "UnityEngine.Transform", "GetParent", "get_parentInternal" },
        .child_count = .{ "UnityEngine.Transform", "get_childCount" },
        .child = .{ "UnityEngine.Transform", "GetChild" },
        .sibling_index = .{ "UnityEngine.Transform", "GetSiblingIndex" },
        .game_object = .{ "UnityEngine.Component", "get_gameObject" },
        .active_self = .{ "UnityEngine.GameObject", "get_activeSelf" },
        .active_in_hierarchy = .{ "UnityEngine.GameObject", "get_activeInHierarchy" },
        .set_active = .{ "UnityEngine.GameObject", "SetActive" },
        .components = .{ "UnityEngine.GameObject", "GetComponentsInternal" },
        .get_local_position = .{ "UnityEngine.Transform", "get_localPosition_Injected", "INTERNAL_get_localPosition" },
        .set_local_position = .{ "UnityEngine.Transform", "set_localPosition_Injected", "INTERNAL_set_localPosition" },
        .get_local_rotation = .{ "UnityEngine.Transform", "get_localRotation_Injected", "INTERNAL_get_localRotation" },
        .set_local_rotation = .{ "UnityEngine.Transform", "set_localRotation_Injected", "INTERNAL_set_localRotation" },
        .get_local_scale = .{ "UnityEngine.Transform", "get_localScale_Injected", "INTERNAL_get_localScale" },
        .set_local_scale = .{ "UnityEngine.Transform", "set_localScale_Injected", "INTERNAL_set_localScale" },
    };
};

/// A GameObject, by its Transform. Natives are Unity's own objects, which go to 0 in the C# ones
/// once Unity destroys them.
pub const Target = struct {
    transform: usize = 0,
    native: usize = 0,
    object: usize = 0,
    object_native: usize = 0,
};

pub const Node = struct {
    target: Target,
    name: []const u8,
    active: bool,
    parent: i32 = -1,
    first_child: i32 = -1,
    next: i32 = -1,
    sibling: i32,
    parent_native: usize,
};

pub const Tree = struct {
    nodes: []const Node,
    first_root: i32,
    /// There were more than it shows
    cut: bool,
};

/// How a field's shown and changed.
pub const Kind = enum { flag, i8, u8, i16, u16, char, i32, u32, i64, u64, f32, f64, text, vec2, vec3, vec4, quat, color, enumeration, structure, reference };

pub const FieldValue = union(enum) {
    flag: bool,
    integer: i64,
    number: f64,
    text: []const u8,
    floats: [4]f32,
    /// A struct's or object's address, or 0 for null
    address: usize,
    /// Its type hasn't been looked up yet
    unknown,
};

pub const Field = struct {
    name: []const u8,
    type: []const u8,
    kind: Kind,
    offset: usize,
    /// For enums, how many bytes
    size: u8,
    value: FieldValue,
};

pub const Component = struct {
    class: []const u8,
    object: usize,
    native: usize,
    fields: []const Field,
};

pub const Details = struct {
    target: Target,
    gone: bool,
    name: []const u8 = "",
    active: bool = false,
    in_hierarchy: bool = false,
    position: Vec3 = .{},
    /// Degrees, the way Unity shows them
    rotation: Vec3 = .{},
    scale: Vec3 = .{},
    components: []const Component = &.{},
};

const Text = struct {
    buf: [256]u8 = undefined,
    len: u16 = 0,

    fn init(s: []const u8) Text {
        var t: Text = .{ .len = @intCast(@min(s.len, 256)) };
        @memcpy(t.buf[0..t.len], s[0..t.len]);
        return t;
    }

    fn get(t: *const Text) []const u8 {
        return t.buf[0..t.len];
    }
};

/// What the panel asks the tick to do.
const Action = union(enum) {
    select: Target,
    set_active: struct { target: Target, on: bool },
    set_local: struct { target: Target, what: enum { position, rotation, scale }, value: Vec3 },
    /// All of it, from the gizmo
    set_transform: struct { target: Target, local: Local },
    /// Plain bytes in a component: numbers, flags, enums and float structs
    set_bytes: struct { component: usize, native: usize, offset: usize, bytes: [16]u8, len: u8 },
    set_text: struct { component: usize, native: usize, field: Text, text: Text },
    focus: Target,
    /// It and what's under it, for the clipboard
    copy: Target,
    refresh,
};

/// Lines for the clipboard, from the tick.
const Copied = struct {
    /// Which copy it is, so the panel copies each once
    seq: u32,
    lines: []const []const u8,
};

/// Most a copy goes through
const max_copied = 5000;
/// Deeper than any game's hierarchy goes, so a loop can't run away
const max_copy_depth = 256;

/// A type's fields, own and inherited, up to Unity's base classes.
const FieldInfo = struct { name: []const u8, type: []const u8, offset: usize };
const TypeInfo = struct { kind: Kind, size: u8 };

pub const gizmo_tools = [_][:0]const u8{ "No gizmo", "Move", "Rotate", "Scale" };

/// A tree being walked, a slice a tick.
const Walk = struct {
    array: *Object,
    hold: u32,
    count: usize,
    at: usize = 0,
    a: std.mem.Allocator,
    nodes: std.ArrayList(Node) = .empty,
};

pub const Explorer = struct {
    managed: W.Managed = undefined,
    engine: *const Engine = undefined,
    scene: *Scene = undefined,
    calls: Calls = undefined,
    tools: ?W.FreeCamera = null,
    ticks: ?sdk.Lease = null,
    transform_type: usize = 0,
    component_type: usize = 0,
    tick_sub: ?sdk.threads.Subscription = null,
    /// The Workbench's Unity tab, holding Scene, and others' that name `unity` as their parent
    holder: sdk.workbench.Holder = .{ .options = .{ .title = "Unity", .kind = "unity" } },
    tab: ?sdk.workbench.Tab = null,
    panel: ?sdk.workbench.Panel = null,

    tree: sdk.workbench.Latest(Tree) = .{},
    details: sdk.workbench.Latest(Details) = .{},
    copied: sdk.workbench.Latest(Copied) = .{},
    actions: sdk.workbench.Queue(Action) = .{},
    /// Handles on the picked one. Wraith draws them, and every call's fine from any thread
    gizmo: ?sdk.overlay.Gizmo = null,
    /// Which of `gizmo_tools`, set from the panel
    gizmo_tool: sdk.atomic.Value(u8) = .init(1),

    // Game thread from here down
    /// The gizmo's been told to show, and not to hide since
    gizmo_shown: bool = false,
    walk: ?Walk = null,
    /// Walked, but a reader had the last one
    unpublished_tree: ?Tree = null,
    unpublished_details: ?Details = null,
    tree_due: u64 = 0,
    details_due: u64 = 0,
    selected: ?Target = null,
    /// On the selected Transform and GameObject
    selected_holds: [2]u32 = .{ 0, 0 },
    by_native: std.AutoHashMapUnmanaged(usize, i32) = .empty,
    types_arena: std.heap.ArenaAllocator = .init(gpa),
    class_fields: std.StringHashMapUnmanaged([]const FieldInfo) = .empty,
    /// Class names by an object's first word, its class or vtable, so a copy asks once a class
    class_names: std.AutoHashMapUnmanaged(usize, []const u8) = .empty,
    copies: u32 = 0,
    unpublished_copy: ?Copied = null,
    types: std.StringHashMapUnmanaged(TypeInfo) = .empty,

    // Workbench thread from here down
    filter: [128:0]u8 = @splat(0),
    gizmo_choice: usize = 1,
    gizmo_world: bool = false,
    split: ui.Split = .{ .direction = .down, .ratio = 0.5 },
    picked: Target = .{},
    /// What's being edited, so a drag or a text box keeps its own value till it's let go
    held_key: u64 = 0,
    held_floats: [4]f32 = undefined,
    held_number: f64 = 0,
    held_integer: i64 = 0,
    held_text: [256:0]u8 = @splat(0),
    /// The component under the mouse when the menu opened
    menu_component: ?usize = null,
    menu_class: [256:0]u8 = @splat(0),
    /// The last copy put on the clipboard
    copied_seq: u32 = 0,

    /// Blocks while the game's runtime looks, so not on the render thread. Panel and all, or
    /// nothing if this Unity's missing what it needs.
    pub fn start(self: *Explorer, engine: *const Engine, scene: *Scene, managed: W.Managed, tools: ?W.FreeCamera, ticks: ?sdk.Lease) !void {
        self.* = .{ .engine = engine, .scene = scene, .managed = managed, .tools = tools, .ticks = ticks };
        var missing: []const u8 = "";
        self.calls = engine_.findCalls(Calls, Calls.names, managed, &missing) catch |err| {
            log.warn("No Scene panel, since this Unity's missing {s}", .{missing});
            return err;
        };
        self.transform_type = try managed.typeObject("UnityEngine.Transform");
        self.component_type = try managed.typeObject("UnityEngine.Component");
        self.tick_sub = try sdk.threads.onTick(self, tick);
        self.addTabs() catch |err| {
            if (self.tab) |t| t.remove();
            self.tab = null;
            self.tick_sub.?.unsubscribe();
            self.tick_sub = null;
            return err;
        };
        // No gizmo without the overlay, but the panel's still fine
        self.gizmo = sdk.overlay.addGizmo() catch null;
        if (self.gizmo) |g| g.setTool(.move);
    }

    fn addTabs(self: *Explorer) !void {
        self.tab = try sdk.workbench.addHolder(&self.holder);
        self.panel = try sdk.workbench.addPanel(self, draw, .{ .title = "Scene", .kind = "scene", .parent = "unity" });
    }

    /// Waits for a tick or draw in flight, so it's fine to free what they use after.
    pub fn stop(self: *Explorer) void {
        if (self.panel) |p| p.remove();
        if (self.tab) |t| t.remove();
        if (self.tick_sub) |s| s.unsubscribe();
        if (self.gizmo) |g| g.remove();
        self.panel = null;
        self.tab = null;
        self.tick_sub = null;
        self.gizmo = null;
        if (self.walk) |*w| self.endWalk(w);
        self.walk = null;
        self.unhold();
        self.by_native.deinit(gpa);
        self.class_fields.deinit(gpa);
        self.class_names.deinit(gpa);
        self.copied.deinit();
        self.types.deinit(gpa);
        self.types_arena.deinit();
        self.tree.deinit();
        self.details.deinit();
        self.actions.deinit();
    }

    // The game thread

    /// Unity's main thread, once a frame, while Unity drives ticks.
    fn tick(self: *Explorer) void {
        // Ticks on the render thread would call Unity from the wrong thread
        const ticks = self.ticks orelse return;
        if (!ticks.held()) return;
        for (self.actions.drain()) |a| self.apply(a);
        if (self.unpublished_copy) |c| {
            if (self.copied.publish(c)) self.unpublished_copy = null;
        }
        self.tickGizmo();
        if (!self.panelOpen()) return;
        const now = sdk.timing.now();
        if (self.unpublished_tree) |t| {
            if (self.tree.publish(t)) self.unpublished_tree = null;
        } else if (self.walk) |*w| {
            self.walkSome(w);
        } else if (now >= self.tree_due) {
            self.tree_due = now + tree_every_ns;
            self.startWalk();
        }
        if (self.unpublished_details) |d| {
            if (self.details.publish(d)) self.unpublished_details = null;
        } else if (self.selected != null and now >= self.details_due) {
            self.details_due = now + details_every_ns;
            const d = self.readDetails(self.details.next());
            if (!self.details.publish(d)) self.unpublished_details = d;
        }
    }

    /// Shows the gizmo on the picked one while Scene's open with a tool picked, moves it where it's
    /// dragged, and keeps it placed where it is.
    fn tickGizmo(self: *Explorer) void {
        const g = self.gizmo orelse return;
        const picked = self.selected;
        const transform: ?*Object = if (picked) |t| @ptrFromInt(t.transform) else null;
        // Held, so a plain read's fine
        const live = if (picked) |t| self.scene.nativeOf(transform.?) == t.native else false;
        if (self.gizmo_tool.load(.monotonic) == 0 or !self.panelOpen() or !live) {
            if (self.gizmo_shown) g.hide();
            self.gizmo_shown = false;
            return;
        }
        if (!self.gizmo_shown) g.show();
        self.gizmo_shown = true;
        var world: Mat4 = .identity;
        var parent: Mat4 = .identity;
        if (self.calls.parent(transform.?)) |p| self.engine.local_to_world(p, &parent);
        if (g.moved()) |m| {
            // Unity sets transforms by their parents', so take the parent's off
            if (parent.inverse()) |from_parent| self.apply(.{ .set_transform = .{ .target = picked.?, .local = .of(m.mul(from_parent)) } });
        }
        self.engine.local_to_world(transform.?, &world);
        g.place(world);
    }

    /// Any thread.
    fn panelOpen(self: *const Explorer) bool {
        return if (self.panel) |p| p.isOpen() else false;
    }

    fn startWalk(self: *Explorer) void {
        // On the stack, where the garbage collector sees it, till it's held
        const array = self.calls.find_objects(@ptrFromInt(self.transform_type), true) orelse return;
        const hold = self.managed.hold(@intFromPtr(array)) catch return;
        const count = @min(local.load(usize, @intFromPtr(array) + array_length) catch 0, max_nodes);
        self.walk = .{ .array = array, .hold = hold, .count = count, .a = self.tree.next() };
        self.walk.?.nodes.ensureTotalCapacity(self.walk.?.a, count) catch {};
    }

    fn walkSome(self: *Explorer, w: *Walk) void {
        const started = sdk.timing.now();
        const items: [*]const ?*Object = @ptrFromInt(@intFromPtr(w.array) + array_items);
        while (w.at < w.count) {
            if (w.at % 32 == 0 and sdk.timing.now() - started > walk_budget_ns) return;
            const t = items[w.at] orelse {
                w.at += 1;
                continue;
            };
            w.at += 1;
            const native = self.scene.nativeOf(t);
            if (native == 0) continue;
            const go = self.calls.game_object(t) orelse continue;
            const go_native = self.scene.nativeOf(go);
            const parent: usize = if (self.calls.parent(t)) |p| self.scene.nativeOf(p) else 0;
            const name = self.scene.nameOf(go, go_native);
            w.nodes.append(w.a, .{
                .target = .{ .transform = @intFromPtr(t), .native = native, .object = @intFromPtr(go), .object_native = go_native },
                .name = w.a.dupe(u8, name.get()) catch "",
                .active = self.calls.active_self(go),
                .sibling = self.calls.sibling_index(t),
                .parent_native = parent,
            }) catch break;
        }
        const tree = self.link(w);
        self.endWalk(w);
        self.walk = null;
        if (!self.tree.publish(tree)) self.unpublished_tree = tree;
    }

    fn endWalk(self: *Explorer, w: *Walk) void {
        self.managed.release(w.hold);
    }

    /// Children in Unity's order under their parents, by their natives.
    fn link(self: *Explorer, w: *Walk) Tree {
        const nodes = w.nodes.items;
        self.by_native.clearRetainingCapacity();
        for (nodes, 0..) |n, i| self.by_native.put(gpa, n.target.native, @intCast(i)) catch {};
        for (nodes) |*n| n.parent = if (n.parent_native != 0) self.by_native.get(n.parent_native) orelse -1 else -1;
        const order = w.a.alloc(u32, nodes.len) catch return .{ .nodes = nodes, .first_root = -1, .cut = true };
        for (order, 0..) |*o, i| o.* = @intCast(i);
        std.mem.sort(u32, order, nodes, struct {
            fn less(ns: []Node, x: u32, y: u32) bool {
                if (ns[x].parent != ns[y].parent) return ns[x].parent < ns[y].parent;
                return ns[x].sibling < ns[y].sibling;
            }
        }.less);
        // Last first, so each list ends up in order
        var first_root: i32 = -1;
        var i = order.len;
        while (i > 0) {
            i -= 1;
            const at: i32 = @intCast(order[i]);
            const n = &nodes[order[i]];
            if (n.parent >= 0) {
                const p = &nodes[@intCast(n.parent)];
                n.next = p.first_child;
                p.first_child = at;
            } else {
                n.next = first_root;
                first_root = at;
            }
        }
        return .{ .nodes = nodes, .first_root = first_root, .cut = w.count == max_nodes };
    }

    /// Still the object it was, and not destroyed. For objects that may be long gone, so it checks
    /// the memory's there first.
    fn alive(self: *const Explorer, object: usize, native: usize) bool {
        if (object == 0 or native == 0) return false;
        return (local.load(usize, object + self.scene.cached_ptr) catch return false) == native;
    }

    fn apply(self: *Explorer, action: Action) void {
        switch (action) {
            .select => |t| {
                self.unhold();
                self.selected = t;
                self.selected_holds = .{ self.managed.hold(t.transform) catch 0, self.managed.hold(t.object) catch 0 };
                self.details_due = 0;
            },
            .set_active => |s| if (self.alive(s.target.object, s.target.object_native)) {
                self.calls.set_active(@ptrFromInt(s.target.object), s.on);
                self.details_due = 0;
                self.tree_due = 0;
            },
            .set_local => |s| if (self.alive(s.target.transform, s.target.native)) {
                const t: *Object = @ptrFromInt(s.target.transform);
                switch (s.what) {
                    .position => self.calls.set_local_position(t, &s.value),
                    .rotation => self.calls.set_local_rotation(t, &fromEuler(s.value)),
                    .scale => self.calls.set_local_scale(t, &s.value),
                }
                self.details_due = 0;
            },
            .set_transform => |s| if (self.alive(s.target.transform, s.target.native)) {
                const t: *Object = @ptrFromInt(s.target.transform);
                self.calls.set_local_position(t, &s.local.position);
                self.calls.set_local_rotation(t, &s.local.rotation);
                self.calls.set_local_scale(t, &s.local.scale);
                self.details_due = 0;
            },
            .set_bytes => |s| if (self.alive(s.component, s.native)) {
                const at: [*]u8 = @ptrFromInt(s.component + s.offset);
                @memcpy(at[0..s.len], s.bytes[0..s.len]);
                self.details_due = 0;
            },
            .set_text => |s| if (self.alive(s.component, s.native)) {
                self.managed.setField(s.component, s.field.get(), .{ .kind = .text, .text = s.text.get() }) catch |err| log.warn("Couldn't set {s}: {t}", .{ s.field.get(), err });
                self.details_due = 0;
            },
            .focus => |t| if (self.alive(t.transform, t.native)) {
                const tools = self.tools orelse return;
                var at: Vec3 = .{};
                self.engine.get_position(@ptrFromInt(t.transform), &at);
                tools.focus(at);
            },
            .copy => |t| if (self.alive(t.transform, t.native)) {
                self.copies +%= 1;
                const c: Copied = .{ .seq = self.copies, .lines = self.hierarchy(self.copied.next(), t) catch &.{} };
                if (!self.copied.publish(c)) self.unpublished_copy = c;
            },
            .refresh => {
                self.tree_due = 0;
                self.details_due = 0;
            },
        }
    }

    /// It and everything under it, one a line, indented by depth: its name, whether it's on, and
    /// its components.
    fn hierarchy(self: *Explorer, a: std.mem.Allocator, top: Target) ![]const []const u8 {
        var lines: std.ArrayList([]const u8) = .empty;
        try self.copyNode(a, &lines, @ptrFromInt(top.transform), 0);
        return lines.items;
    }

    /// Recursing, so each child's on the stack, where the garbage collector sees it, while it's
    /// asked about.
    fn copyNode(self: *Explorer, a: std.mem.Allocator, lines: *std.ArrayList([]const u8), t: *Object, depth: u32) !void {
        if (lines.items.len >= max_copied or depth > max_copy_depth) {
            if (lines.items.len == max_copied) try lines.append(a, "...and more");
            return;
        }
        if (self.scene.nativeOf(t) == 0) return;
        const go = self.calls.game_object(t) orelse return;
        var line: std.Io.Writer.Allocating = .init(a);
        const w = &line.writer;
        for (0..depth) |_| try w.writeAll("  ");
        try w.print("{s}\t{s}\t", .{ self.scene.nameOf(go, self.scene.nativeOf(go)).get(), if (self.calls.active_self(go)) "on" else "off" });
        try self.writeComponents(w, go);
        try lines.append(a, line.written());
        const n = self.calls.child_count(t);
        var k: i32 = 0;
        while (k < n) : (k += 1) {
            const child = self.calls.child(t, k) orelse continue;
            try self.copyNode(a, lines, child, depth + 1);
        }
    }
    /// Its components' classes, but the Transform everything has.
    fn writeComponents(self: *Explorer, w: *std.Io.Writer, go: *Object) !void {
        // On the stack, where the garbage collector sees it
        const array = self.calls.components(go, @ptrFromInt(self.component_type), true, false, true, false, null) orelse return;
        const n = @min(try local.load(usize, @intFromPtr(array) + array_length), max_components);
        const items: [*]const ?*Object = @ptrFromInt(@intFromPtr(array) + array_items);
        var first = true;
        for (items[0..n]) |item| {
            const object = item orelse continue;
            const name = self.classNameOf(object) orelse continue;
            if (std.mem.eql(u8, name, "UnityEngine.Transform")) continue;
            if (!first) try w.writeAll(", ");
            first = false;
            try w.writeAll(name);
        }
    }

    fn classNameOf(self: *Explorer, object: *Object) ?[]const u8 {
        const class: usize = @as(*const usize, @ptrCast(@alignCast(object))).*;
        if (self.class_names.get(class)) |n| return n;
        const name = self.types_arena.allocator().dupe(u8, self.managed.classOf(@intFromPtr(object)) catch return null) catch return null;
        self.class_names.put(gpa, class, name) catch {};
        return name;
    }

    fn unhold(self: *Explorer) void {
        for (self.selected_holds) |h| if (h != 0) self.managed.release(h);
        self.selected_holds = .{ 0, 0 };
    }

    fn readDetails(self: *Explorer, a: std.mem.Allocator) Details {
        const t = self.selected.?;
        if (!self.alive(t.transform, t.native) or !self.alive(t.object, t.object_native)) return .{ .target = t, .gone = true };
        const transform: *Object = @ptrFromInt(t.transform);
        const go: *Object = @ptrFromInt(t.object);
        var d: Details = .{
            .target = t,
            .gone = false,
            .name = a.dupe(u8, self.scene.nameOf(go, t.object_native).get()) catch "",
            .active = self.calls.active_self(go),
            .in_hierarchy = self.calls.active_in_hierarchy(go),
        };
        var rotation: Quat = .identity;
        self.calls.get_local_position(transform, &d.position);
        self.calls.get_local_rotation(transform, &rotation);
        self.calls.get_local_scale(transform, &d.scale);
        d.rotation = toEuler(rotation);
        d.components = self.readComponents(a, go) catch &.{};
        return d;
    }

    fn readComponents(self: *Explorer, a: std.mem.Allocator, go: *Object) ![]const Component {
        // On the stack, where the garbage collector sees it
        const array = self.calls.components(go, @ptrFromInt(self.component_type), true, false, true, false, null) orelse return &.{};
        const n = @min(try local.load(usize, @intFromPtr(array) + array_length), max_components);
        const items: [*]const ?*Object = @ptrFromInt(@intFromPtr(array) + array_items);
        var out: std.ArrayList(Component) = .empty;
        var new_types: u32 = 0;
        for (items[0..n]) |item| {
            const object = item orelse continue;
            const address = @intFromPtr(object);
            const class = a.dupe(u8, self.managed.classOf(address) catch continue) catch continue;
            const infos = self.fieldsOf(class) catch &.{};
            const fields = try a.alloc(Field, @min(infos.len, max_fields));
            for (fields, infos[0..fields.len]) |*f, info| {
                const ti = self.typeOf(info.type, &new_types);
                f.* = .{ .name = info.name, .type = info.type, .kind = if (ti) |x| x.kind else .reference, .offset = info.offset, .size = if (ti) |x| x.size else 0, .value = .unknown };
                if (ti != null) f.value = readValue(a, address + info.offset, f.kind, f.size);
            }
            try out.append(a, .{ .class = class, .object = address, .native = self.scene.nativeOf(object), .fields = fields });
        }
        return out.items;
    }

    /// Unity's own base classes, whose fields are its internals.
    fn isBase(class: []const u8) bool {
        const bases = [_][]const u8{ "UnityEngine.Object", "UnityEngine.Component", "UnityEngine.Behaviour", "UnityEngine.MonoBehaviour", "System.Object" };
        for (bases) |b| if (std.mem.eql(u8, b, class)) return true;
        return false;
    }

    /// Kept for good, since a class's fields don't change.
    fn fieldsOf(self: *Explorer, class: []const u8) ![]const FieldInfo {
        if (self.class_fields.get(class)) |f| return f;
        const a = self.types_arena.allocator();
        var out: std.ArrayList(FieldInfo) = .empty;
        var name = try a.dupe(u8, class);
        const key = name;
        var depth: u32 = 0;
        while (!isBase(name) and depth < 16) : (depth += 1) {
            // Copied before the next call into Wraith, which reuses what it gave back
            for (self.managed.fields(name) catch break) |f| {
                if (f.is_static or f.literal) continue;
                try out.append(a, .{ .name = try a.dupe(u8, f.name), .type = try a.dupe(u8, f.type), .offset = f.offset });
            }
            const info = self.managed.find(name) catch break;
            if (info.parent.len == 0) break;
            name = try a.dupe(u8, info.parent);
        }
        try self.class_fields.put(gpa, key, out.items);
        return out.items;
    }

    /// Null if it hasn't been looked up, and this refresh has looked up enough.
    fn typeOf(self: *Explorer, type_name: []const u8, new_types: *u32) ?TypeInfo {
        if (plainKind(type_name)) |k| return .{ .kind = k, .size = 0 };
        if (self.types.get(type_name)) |t| return t;
        if (new_types.* >= max_new_types) return null;
        new_types.* += 1;
        const info: TypeInfo = if (self.managed.find(type_name)) |c| blk: {
            if (!c.value_type) break :blk .{ .kind = .reference, .size = 0 };
            const bytes = c.size -| 2 * word;
            if (std.mem.eql(u8, c.parent, "System.Enum") and (bytes == 1 or bytes == 2 or bytes == 4 or bytes == 8)) break :blk .{ .kind = .enumeration, .size = @intCast(bytes) };
            break :blk .{ .kind = .structure, .size = 0 };
        } else |_| .{ .kind = .reference, .size = 0 };
        const key = self.types_arena.allocator().dupe(u8, type_name) catch return info;
        self.types.put(gpa, key, info) catch {};
        return info;
    }

    // The Workbench's thread

    fn draw(self: *Explorer) void {
        self.takeCopy();
        if (self.split.first("tree")) |part| {
            defer part.end();
            self.drawTree();
        }
        if (self.split.second("inspector")) |part| {
            defer part.end();
            self.drawInspector();
        }
    }

    fn drawTree(self: *Explorer) void {
        ui.setNextItemWidth(220);
        _ = ui.inputTextHint("##filter", "Filter by name", &self.filter);
        const reading = self.tree.read() orelse {
            ui.sameLine();
            ui.textDisabled("Asking Unity...", .{});
            return;
        };
        defer reading.end();
        const tree = reading.value;
        ui.sameLine();
        ui.textDisabled("{d} objects{s}", .{ tree.nodes.len, if (tree.cut) ", and more" else "" });

        const text = std.mem.trim(u8, std.mem.sliceTo(&self.filter, 0), " \t");
        if (ui.child("nodes", .{ 0, 0 }, .{})) |list| {
            defer list.end();
            if (text.len == 0) {
                var at = tree.first_root;
                while (at >= 0) : (at = tree.nodes[@intCast(at)].next) self.drawNode(tree, @intCast(at));
            } else self.drawMatches(tree, text);
            self.treeCommands(tree);
        }
    }

    fn drawNode(self: *Explorer, tree: *const Tree, i: usize) void {
        const n = &tree.nodes[i];
        var flags: c_int = ui.c.ImGuiTreeNodeFlags_OpenOnArrow | ui.c.ImGuiTreeNodeFlags_OpenOnDoubleClick | ui.c.ImGuiTreeNodeFlags_SpanAvailWidth;
        if (n.first_child < 0) flags |= ui.c.ImGuiTreeNodeFlags_Leaf;
        if (n.target.native == self.picked.native) flags |= ui.c.ImGuiTreeNodeFlags_Selected;
        if (!n.active) ui.raw("ImGui_PushStyleColorImVec4")(ui.c.ImGuiCol_Text, ui.raw("ImGui_GetStyleColorVec4")(ui.c.ImGuiCol_TextDisabled).*);
        const open = ui.raw("ImGui_TreeNodeEx")(ui.str(ui.format("{s}###{x}", .{ if (n.name.len > 0) n.name else "(no name)", n.target.native })), flags);
        if (!n.active) ui.raw("ImGui_PopStyleColor")();
        if (ui.raw("ImGui_IsItemClicked")() and !ui.raw("ImGui_IsItemToggledOpen")()) self.pick(n.target);
        if (!open) return;
        defer ui.raw("ImGui_TreePop")();
        var at = n.first_child;
        while (at >= 0) : (at = tree.nodes[@intCast(at)].next) self.drawNode(tree, @intCast(at));
    }

    /// A flat list of what matches, with each one's parent.
    fn drawMatches(self: *Explorer, tree: *const Tree, text: []const u8) void {
        var shown: usize = 0;
        for (tree.nodes) |*n| {
            if (std.ascii.findIgnoreCase(n.name, text) == null) continue;
            if (shown == max_matches) {
                ui.textDisabled("And more. Type more of the name to narrow it down.", .{});
                break;
            }
            shown += 1;
            const parent = if (n.parent >= 0) tree.nodes[@intCast(n.parent)].name else "";
            if (ui.selectable(ui.format("{s}  {s}###{x}", .{ n.name, parent, n.target.native }), n.target.native == self.picked.native)) self.pick(n.target);
        }
        if (shown == 0) ui.textDisabled("Nothing's called that.", .{});
    }

    fn pick(self: *Explorer, t: Target) void {
        self.picked = t;
        self.actions.push(.{ .select = t });
        // In front again, even over posing's
        if (self.gizmo) |g| g.show();
    }

    fn treeCommands(self: *Explorer, tree: *const Tree) void {
        _ = tree;
        var menu = ui.commands("scene", .{});
        defer menu.end();
        const any = self.picked.native != 0;
        if (menu.item(.{ .label = "Orbit the camera round it", .enabled = any and self.tools != null, .default = true, .tooltip = "The free camera takes over and orbits where it is" })) self.actions.push(.{ .focus = self.picked });
        if (menu.item(.{ .label = "Turn on or off", .enabled = any, .tooltip = "Its GameObject's SetActive" })) {
            const on = if (self.details.read()) |d| blk: {
                defer d.end();
                break :blk if (d.value.target.native == self.picked.native) !d.value.active else true;
            } else true;
            self.actions.push(.{ .set_active = .{ .target = self.picked, .on = on } });
        }
        if (menu.item(.{ .label = "Copy", .chord = ui.copy_chord, .enabled = any, .tooltip = "It and everything under it, one a line: its name, whether it's on, and its components" })) self.actions.push(.{ .copy = self.picked });
        menu.separator();
        if (menu.item(.{ .label = "Refresh", .tooltip = "Asks Unity again now" })) self.actions.push(.refresh);
    }

    /// Puts a copy on the clipboard once the tick's made it.
    fn takeCopy(self: *Explorer) void {
        const reading = self.copied.read() orelse return;
        defer reading.end();
        const c = reading.value;
        if (c.seq == self.copied_seq) return;
        self.copied_seq = c.seq;
        var clip: ui.Clip = .{};
        for (c.lines) |l| clip.line("{s}", .{l});
        clip.copy();
    }

    fn drawInspector(self: *Explorer) void {
        if (self.picked.native == 0) return ui.textDisabled("Pick something in the tree to see what's on it.", .{});
        const reading = self.details.read() orelse return ui.textDisabled("Asking Unity...", .{});
        defer reading.end();
        const d = reading.value;
        if (d.target.native != self.picked.native) return ui.textDisabled("Asking Unity...", .{});
        if (d.gone) return ui.textDisabled("It's gone. Unity's destroyed it since.", .{});

        var active = d.active;
        if (ui.checkbox("##active", &active)) self.actions.push(.{ .set_active = .{ .target = d.target, .on = active } });
        ui.sameLine();
        ui.text("{s}", .{d.name});
        if (d.active and !d.in_hierarchy) {
            ui.sameLine();
            ui.textDisabled("(off, since one it's under is)", .{});
        }

        if (ui.collapsingHeader("Transform", true)) {
            self.dragLocal(d, "Position", .position, d.position, 0.01);
            self.dragLocal(d, "Rotation", .rotation, d.rotation, 0.5);
            self.dragLocal(d, "Scale", .scale, d.scale, 0.01);
            ui.setNextItemWidth(120);
            if (ui.combo("##gizmo", &self.gizmo_choice, &gizmo_tools)) {
                self.gizmo_tool.store(@intCast(self.gizmo_choice), .monotonic);
                if (self.gizmo) |g| if (self.gizmo_choice != 0) {
                    g.setTool(switch (self.gizmo_choice) {
                        1 => .move,
                        2 => .rotate,
                        else => .scale,
                    });
                    g.show();
                };
            }
            ui.tooltip("Handles on it in the game. Open the overlay to drag them", .{});
            ui.sameLine();
            if (ui.checkbox("World axes", &self.gizmo_world)) if (self.gizmo) |g| g.setWorldAxes(self.gizmo_world);
            ui.tooltip("Along the world's axes rather than its own", .{});
        }
        for (d.components, 0..) |*comp, i| {
            const scope = ui.id(@as(i32, @intCast(i)));
            defer scope.end();
            if (std.mem.eql(u8, comp.class, "UnityEngine.Transform")) continue;
            const open = ui.collapsingHeader(ui.format("{s}###component", .{comp.class}), true);
            if (ui.isItemHovered() and ui.raw("ImGui_IsMouseReleased")(ui.c.ImGuiMouseButton_Right)) {
                self.menu_component = i;
                const n = @min(comp.class.len, self.menu_class.len - 1);
                @memcpy(self.menu_class[0..n], comp.class[0..n]);
                self.menu_class[n] = 0;
            }
            if (open) self.drawFields(comp);
        }
        self.inspectorCommands();
    }

    fn inspectorCommands(self: *Explorer) void {
        var menu = ui.commands("inspector", .{});
        defer menu.end();
        const class = std.mem.sliceTo(&self.menu_class, 0);
        if (menu.item(.{ .label = "Show class", .enabled = class.len > 0, .tooltip = "The component's class, in Classes" })) sdk.workbench.showClass(class);
        if (menu.item(.{ .label = "Refresh", .tooltip = "Asks Unity again now" })) self.actions.push(.refresh);
    }

    fn dragLocal(self: *Explorer, d: *const Details, label: [:0]const u8, what: @FieldType(@FieldType(Action, "set_local"), "what"), value: Vec3, speed: f32) void {
        const key = std.hash.Wyhash.hash(d.target.native, label);
        var v = if (self.held_key == key) Vec3{ .x = self.held_floats[0], .y = self.held_floats[1], .z = self.held_floats[2] } else value;
        ui.setNextItemWidth(ui.fill);
        const changed = ui.drag(ui.format("{s}", .{label}), &v, speed);
        self.holdEdit(key, .{ v.x, v.y, v.z, 0 });
        if (changed) self.actions.push(.{ .set_local = .{ .target = d.target, .what = what, .value = v } });
    }

    /// Keeps what's being edited past the snapshot, till it's let go.
    fn holdEdit(self: *Explorer, key: u64, floats: [4]f32) void {
        if (ui.isItemActive()) {
            self.held_key = key;
            self.held_floats = floats;
        } else if (self.held_key == key) self.held_key = 0;
    }

    fn drawFields(self: *Explorer, comp: *const Component) void {
        if (comp.fields.len == 0) return ui.textDisabled("No fields of its own.", .{});
        const table = ui.table("fields", 2, .{ .borders = true, .resizable = true, .sizing = .stretch_prop }) orelse return;
        defer table.end();
        ui.tableColumnWith("Field", .{ .stretch = true, .width = 2 });
        ui.tableColumnWith("Value", .{ .stretch = true, .width = 3 });
        for (comp.fields, 0..) |*f, i| {
            const scope = ui.id(@as(i32, @intCast(i)));
            defer scope.end();
            ui.tableNextRow();
            _ = ui.tableNextColumn();
            ui.text("{s}", .{f.name});
            if (ui.isItemHovered()) ui.tooltip("{s}, at 0x{x}", .{ f.type, f.offset });
            _ = ui.tableNextColumn();
            ui.setNextItemWidth(ui.fill);
            self.drawValue(comp, f);
        }
    }

    fn drawValue(self: *Explorer, comp: *const Component, f: *const Field) void {
        const key = std.hash.Wyhash.hash(comp.native, f.name);
        const held = self.held_key == key;
        switch (f.value) {
            .unknown => ui.textDisabled("...", .{}),
            .flag => |b| {
                var v = b;
                if (ui.checkbox("##v", &v)) self.setBytes(comp, f, std.mem.asBytes(&v)[0..1]);
            },
            .integer => |n| {
                var v: i64 = if (held) self.held_integer else n;
                const changed = ui.inputNumber("##v", &v, .{});
                if (ui.isItemActive()) {
                    self.held_key = key;
                    self.held_integer = v;
                } else if (held) self.held_key = 0;
                if (changed) self.setInteger(comp, f, v);
            },
            .number => |x| {
                if (f.kind == .f32) {
                    var v: f32 = if (held) self.held_floats[0] else @floatCast(x);
                    const changed = ui.drag("##v", &v, 0.01);
                    self.holdEdit(key, .{ v, 0, 0, 0 });
                    if (changed) self.setBytes(comp, f, std.mem.asBytes(&v));
                } else {
                    var v: f64 = if (held) self.held_number else x;
                    const changed = ui.inputNumber("##v", &v, .{});
                    if (ui.isItemActive()) {
                        self.held_key = key;
                        self.held_number = v;
                    } else if (held) self.held_key = 0;
                    if (changed) self.setBytes(comp, f, std.mem.asBytes(&v));
                }
            },
            .text => |s| {
                // The one being typed in keeps its own, the rest show what Unity has
                var scratch: [256:0]u8 = undefined;
                const buf: *[256:0]u8 = if (held) &self.held_text else blk: {
                    const n = @min(s.len, scratch.len);
                    @memcpy(scratch[0..n], s[0..n]);
                    scratch[n] = 0;
                    break :blk &scratch;
                };
                _ = ui.inputText("##v", buf);
                if (ui.isItemActive()) {
                    if (!held) self.held_text = buf.*;
                    self.held_key = key;
                } else if (held) self.held_key = 0;
                // Each change makes a C# string, so it's set once it's left
                if (ui.isItemDeactivatedAfterEdit()) self.actions.push(.{ .set_text = .{ .component = comp.object, .native = comp.native, .field = .init(f.name), .text = .init(std.mem.sliceTo(buf, 0)) } });
            },
            .floats => |fl| {
                const n: usize = switch (f.kind) {
                    .vec2 => 2,
                    .vec3 => 3,
                    else => 4,
                };
                var v = if (held) self.held_floats else fl;
                const changed = switch (n) {
                    2 => ui.raw("ImGui_DragFloat2Ex")(ui.str("##v"), @ptrCast(&v), 0.01, 0, 0, ui.str("%.3f"), 0),
                    3 => ui.raw("ImGui_DragFloat3Ex")(ui.str("##v"), @ptrCast(&v), 0.01, 0, 0, ui.str("%.3f"), 0),
                    else => ui.raw("ImGui_DragFloat4Ex")(ui.str("##v"), @ptrCast(&v), 0.01, 0, 0, ui.str("%.3f"), 0),
                };
                self.holdEdit(key, v);
                if (changed) self.setBytes(comp, f, std.mem.sliceAsBytes(v[0..n]));
            },
            .address => |at| switch (f.kind) {
                .structure => ui.textDisabled("{s}", .{shortName(f.type)}),
                else => if (at == 0) ui.textDisabled("null", .{}) else ui.textDisabled("{s} at 0x{x}", .{ shortName(f.type), at }),
            },
        }
    }

    fn setBytes(self: *Explorer, comp: *const Component, f: *const Field, bytes: []const u8) void {
        var a: Action = .{ .set_bytes = .{ .component = comp.object, .native = comp.native, .offset = f.offset, .bytes = undefined, .len = @intCast(@min(bytes.len, 16)) } };
        @memcpy(a.set_bytes.bytes[0..a.set_bytes.len], bytes[0..a.set_bytes.len]);
        self.actions.push(a);
    }

    fn setInteger(self: *Explorer, comp: *const Component, f: *const Field, v: i64) void {
        const size: usize = switch (f.kind) {
            .i8, .u8 => 1,
            .i16, .u16, .char => 2,
            .i32, .u32 => 4,
            .enumeration => f.size,
            else => 8,
        };
        const bytes = std.mem.asBytes(&v);
        self.setBytes(comp, f, bytes[0..size]);
    }
};

/// `Game.Party/Member` as `Member`.
fn shortName(type_name: []const u8) []const u8 {
    const generic = std.mem.indexOfScalar(u8, type_name, '<') orelse type_name.len;
    const head = type_name[0..generic];
    const from = if (std.mem.lastIndexOfAny(u8, head, "./")) |i| i + 1 else 0;
    return type_name[from..];
}

fn plainKind(type_name: []const u8) ?Kind {
    const map = std.StaticStringMap(Kind).initComptime(.{
        .{ "System.Boolean", .flag },
        .{ "System.SByte", .i8 },
        .{ "System.Byte", .u8 },
        .{ "System.Int16", .i16 },
        .{ "System.UInt16", .u16 },
        .{ "System.Char", .char },
        .{ "System.Int32", .i32 },
        .{ "System.UInt32", .u32 },
        .{ "System.Int64", .i64 },
        .{ "System.UInt64", .u64 },
        .{ "System.Single", .f32 },
        .{ "System.Double", .f64 },
        .{ "System.String", .text },
        .{ "UnityEngine.Vector2", .vec2 },
        .{ "UnityEngine.Vector3", .vec3 },
        .{ "UnityEngine.Vector4", .vec4 },
        .{ "UnityEngine.Quaternion", .quat },
        .{ "UnityEngine.Color", .color },
    });
    return map.get(type_name);
}

/// A field's value at `at`, inside an object Unity's just handed over, so plain reads.
fn readValue(a: std.mem.Allocator, at: usize, kind: Kind, size: u8) FieldValue {
    const p: [*]const u8 = @ptrFromInt(at);
    return switch (kind) {
        .flag => .{ .flag = p[0] != 0 },
        .i8 => .{ .integer = std.mem.bytesToValue(i8, p[0..1]) },
        .u8 => .{ .integer = p[0] },
        .i16 => .{ .integer = std.mem.bytesToValue(i16, p[0..2]) },
        .u16, .char => .{ .integer = std.mem.bytesToValue(u16, p[0..2]) },
        .i32 => .{ .integer = std.mem.bytesToValue(i32, p[0..4]) },
        .u32 => .{ .integer = std.mem.bytesToValue(u32, p[0..4]) },
        .i64, .u64 => .{ .integer = std.mem.bytesToValue(i64, p[0..8]) },
        .enumeration => .{ .integer = switch (size) {
            1 => std.mem.bytesToValue(i8, p[0..1]),
            2 => std.mem.bytesToValue(i16, p[0..2]),
            4 => std.mem.bytesToValue(i32, p[0..4]),
            else => std.mem.bytesToValue(i64, p[0..8]),
        } },
        .f32 => .{ .number = std.mem.bytesToValue(f32, p[0..4]) },
        .f64 => .{ .number = std.mem.bytesToValue(f64, p[0..8]) },
        .text => .{ .text = readText(a, std.mem.bytesToValue(usize, p[0..word])) },
        .vec2 => .{ .floats = .{ std.mem.bytesToValue(f32, p[0..4]), std.mem.bytesToValue(f32, p[4..8]), 0, 0 } },
        .vec3 => .{ .floats = .{ std.mem.bytesToValue(f32, p[0..4]), std.mem.bytesToValue(f32, p[4..8]), std.mem.bytesToValue(f32, p[8..12]), 0 } },
        .vec4, .quat, .color => .{ .floats = std.mem.bytesToValue([4]f32, p[0..16]) },
        .structure => .{ .address = at },
        .reference => .{ .address = std.mem.bytesToValue(usize, p[0..word]) },
    };
}

/// A C# string: the header, its length, then UTF-16. Plain reads, as the object holding it is live.
fn readText(a: std.mem.Allocator, at: usize) []const u8 {
    if (at == 0) return "";
    const len: *align(1) const i32 = @ptrFromInt(at + 2 * word);
    const chars: [*]align(1) const u16 = @ptrFromInt(at + 2 * word + 4);
    const n = @min(@as(usize, @intCast(@max(len.*, 0))), 255);
    const units = a.alloc(u16, n) catch return "";
    for (units, chars[0..n]) |*u, ch| u.* = ch;
    return std.unicode.utf16LeToUtf8Alloc(a, units) catch "";
}

const deg = 180.0 / std.math.pi;

/// Unity's `Quaternion.Euler`: z degrees round z, then x round x, then y round y.
pub fn fromEuler(degrees: Vec3) Quat {
    const x = Quat.fromAxisAngle(.unit_x, degrees.x / deg);
    const y = Quat.fromAxisAngle(.unit_y, degrees.y / deg);
    const z = Quat.fromAxisAngle(.unit_z, degrees.z / deg);
    return z.mul(x).mul(y);
}

/// Unity's `eulerAngles`, from -180 to 180.
pub fn toEuler(q: Quat) Vec3 {
    const sx = std.math.clamp(2 * (q.w * q.x - q.y * q.z), -1, 1);
    return .{
        .x = std.math.asin(sx) * deg,
        .y = std.math.atan2(2 * (q.w * q.y + q.x * q.z), 1 - 2 * (q.x * q.x + q.y * q.y)) * deg,
        .z = std.math.atan2(2 * (q.w * q.z + q.x * q.y), 1 - 2 * (q.x * q.x + q.z * q.z)) * deg,
    };
}

const testing = std.testing;

test "euler angles go round Unity's way and back" {
    // Unity's Euler(90, 0, 0) tips forward down
    const down = fromEuler(.{ .x = 90 }).rotate(.unit_z);
    try testing.expect(down.approxEql(.{ .y = -1 }, 1e-5));
    // Y turns forward to the right
    const right = fromEuler(.{ .y = 90 }).rotate(.unit_z);
    try testing.expect(right.approxEql(.{ .x = 1 }, 1e-5));
    const angles: Vec3 = .{ .x = 30, .y = -60, .z = 45 };
    try testing.expect(toEuler(fromEuler(angles)).approxEql(angles, 1e-3));
}

test "short type names" {
    try testing.expectEqualStrings("Member", shortName("Game.Party/Member"));
    try testing.expectEqualStrings("List<Game.Item>", shortName("System.Collections.Generic.List<Game.Item>"));
    try testing.expectEqualStrings("Thing", shortName("Thing"));
}
