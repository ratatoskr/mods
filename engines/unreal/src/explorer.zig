//! The Workbench's Unreal tab, with Scene and Classes in it. Scene has the current world's levels and
//! their actors as a tree, attached actors under what they're attached to, and the picked actor's
//! components and properties, read through the engine's reflection and changed in place. Classes
//! lists every class, struct and enum with their properties and functions.
//!
//! Everything that reads the game happens in a tick on the game thread, and only while a panel's
//! open, where every object in the engine's array is alive. The panels draw on the Workbench's own
//! thread from what the tick last published, and their changes go back through a queue. The object
//! array's walked a slice a tick, so a big game never holds up a frame for long.

const std = @import("std");
const sdk = @import("wraith_sdk");

const Unreal = @import("ue/Unreal.zig");
const TArray = Unreal.TArray;
const World = @import("ue/World.zig");
const objects_ = @import("ue/objects.zig");
const Loop = @import("loop.zig").Loop;
const camera = @import("camera.zig");

const ui = sdk.ui;
const W = sdk.api.wraith;
const Vec3 = sdk.math.Vec3;
const Mat4 = sdk.math.Mat4;
const gpa = std.heap.smp_allocator;

const log = sdk.log.scoped(.unreal);
const object = objects_.object;

/// Asked again this often while a panel's open
const tree_every_ns = 2 * std.time.ns_per_s;
const details_every_ns = 200 * std.time.ns_per_ms;
const classes_every_ns = 10 * std.time.ns_per_s;
/// How long a tick can spend walking the objects
const walk_budget_ns = std.time.ns_per_ms;
/// Most it shows
const max_actors = 50_000;
const max_components = 200_000;
const max_classes = 100_000;
const max_props = 2000;
const max_functions = 600;
const max_depth = 2;
const max_elements = 16;
const max_matches = 500;

/// `RF_ClassDefaultObject` and `RF_ArchetypeObject`, templates rather than things in the world.
const template_flags = 0x10 | 0x20;

/// What an object is, by its class.
const Sort = enum(u8) { other, actor, component, level, class, script_struct, enumeration };

/// A UFunction to call and where its param or answer goes, and a second param if it has one.
const Call = struct {
    function: usize,
    size: usize,
    param: usize,
    second: ?usize = null,
};

/// Room for the params of any function it calls, like `K2_SetActorLocation`'s hit result.
const max_params = 1024;

pub const TransformPart = enum { location, rotation, scale };

pub const gizmo_tools = [_][:0]const u8{ "No gizmo", "Move", "Rotate", "Scale" };

/// A bool property's byte and bit.
const Bit = struct { offset: usize, mask: u8 };

/// What the explorer works with, found as it starts.
const Found = struct {
    actor: usize,
    component: usize,
    scene: usize,
    level: usize,
    class: usize,
    script_struct: usize,
    enumeration: usize,
    world_levels: ?usize,
    root_component: ?usize,
    attach_parent: ?usize,
    hidden: ?Bit,
    actor_location: ?Call,
    component_location: ?Call,
    set_hidden: ?Call,
    get_rotation: ?Call,
    get_scale: ?Call,
    set_location: ?Call,
    set_rotation: ?Call,
    set_scale: ?Call,
    /// SceneComponent's, since static ones won't move
    mobility: ?usize,
    set_mobility: ?Call,
};

pub const Node = struct {
    object: usize,
    level: bool,
    name: []const u8,
    class: []const u8,
    hidden: bool,
    parent: i32 = -1,
    first_child: i32 = -1,
    next: i32 = -1,
    comp_start: u32 = 0,
    comp_count: u32 = 0,
};

pub const Comp = struct {
    object: usize,
    name: []const u8,
    class: []const u8,
};

pub const Tree = struct {
    nodes: []const Node,
    comps: []const Comp,
    first_root: i32,
    /// There were more than it shows
    cut: bool,
};

/// How a property's shown and changed.
pub const Kind = enum { flag, i8, u8, i16, u16, i32, u32, i64, u64, f32, f64, name, text, enumeration, object, floats, structure, array, other };

pub const Value = union(enum) {
    flag: bool,
    integer: i64,
    number: f64,
    text: []const u8,
    /// `n` of them, each `elem` bytes
    floats: struct { v: [4]f64, n: u8, elem: u8 },
    object: usize,
    none,
};

pub const Prop = struct {
    name: []const u8,
    /// Like `FloatProperty`, or a struct's or class's name
    type: []const u8,
    kind: Kind,
    depth: u8,
    /// Where it is in the game, for changing it
    at: usize,
    size: u8,
    /// A bool's bit
    mask: u8 = 0,
    value: Value,
    /// An enum's name for it, or an object's name and class
    label: []const u8 = "",
};

pub const Section = struct {
    name: []const u8,
    first: u32,
    count: u32,
};

pub const Func = struct {
    name: []const u8,
    function: usize,
    class: []const u8,
    params: u32,
    static: bool,
};

pub const Details = struct {
    object: usize,
    gone: bool,
    name: []const u8 = "",
    class_name: []const u8 = "",
    class: usize = 0,
    path: []const u8 = "",
    actor: bool = false,
    hidden: ?bool = null,
    /// An actor's, in the world: location, rotation as pitch, yaw and roll in degrees, and scale
    transform: ?[3][3]f64 = null,
    sections: []const Section = &.{},
    props: []const Prop = &.{},
    functions: []const Func = &.{},
};

pub const ClassEntry = struct {
    class: usize,
    name: []const u8,
    sort: Sort,
};

pub const ClassList = struct {
    entries: []const ClassEntry,
};

pub const Field = struct {
    name: []const u8,
    type: []const u8,
    offset: i32,
    size: i32,
};

pub const ClassDetails = struct {
    class: usize,
    name: []const u8 = "",
    path: []const u8 = "",
    sort: Sort = .other,
    size: i32 = 0,
    supers: []const ClassEntry = &.{},
    fields: []const Field = &.{},
    functions: []const Func = &.{},
};

/// Lines for the clipboard aren't needed from the tick, the tree has it all.
const Action = union(enum) {
    select: usize,
    select_class: usize,
    find_instance: usize,
    /// Plain bytes somewhere in an object: numbers, enums and float structs
    set_bytes: struct { object: usize, at: usize, bytes: [32]u8, len: u8 },
    set_bit: struct { object: usize, at: usize, mask: u8, on: bool },
    set_hidden: struct { object: usize, on: bool },
    set_transform: struct { object: usize, part: TransformPart, value: [3]f64 },
    call: struct { object: usize, function: usize },
    focus: usize,
    refresh,
};

const Raw = struct { object: usize, outer: usize, class: usize };

/// The objects being walked, a slice a tick.
const Walk = struct {
    at: usize = 0,
    count: usize,
    world: usize,
    levels: std.AutoHashMapUnmanaged(usize, void) = .empty,
    actors: std.ArrayList(Raw) = .empty,
    comps: std.ArrayList(Raw) = .empty,
    classes: std.ArrayList(Raw) = .empty,

    fn deinit(w: *Walk) void {
        w.levels.deinit(gpa);
        w.actors.deinit(gpa);
        w.comps.deinit(gpa);
        w.classes.deinit(gpa);
    }
};

pub const Explorer = struct {
    ue: *const Unreal = undefined,
    world: *const World = undefined,
    loop: *Loop = undefined,
    tools: ?W.FreeCamera = null,
    found: Found = undefined,
    /// The Workbench's Unreal tab, holding Scene and Classes, and others' that name `unreal` as their parent
    holder: sdk.workbench.Holder = .{ .options = .{ .title = "Unreal", .kind = "unreal" } },
    tab: ?sdk.workbench.Tab = null,
    scene_panel: ?sdk.workbench.Panel = null,
    classes_panel: ?sdk.workbench.Panel = null,

    tree: sdk.workbench.Latest(Tree) = .{},
    details: sdk.workbench.Latest(Details) = .{},
    classes: sdk.workbench.Latest(ClassList) = .{},
    class_details: sdk.workbench.Latest(ClassDetails) = .{},
    actions: sdk.workbench.Queue(Action) = .{},
    /// An instance the tick found, for the Scene panel to pick
    found_instance: sdk.atomic.Value(usize) = .init(0),
    /// Handles on the picked actor. Wraith draws them, and every call's fine from any thread
    gizmo: ?sdk.overlay.Gizmo = null,
    /// Which of `gizmo_tools`, set from the panel
    gizmo_tool: sdk.atomic.Value(u8) = .init(1),
    /// The actor the panel's on, so the gizmo never shows on one picked before
    gizmo_actor: sdk.atomic.Value(usize) = .init(0),

    // Game thread from here down
    /// The gizmo's been told to show, and not to hide since
    gizmo_shown: bool = false,
    walk: ?Walk = null,
    unpublished_tree: ?Tree = null,
    unpublished_classes: ?ClassList = null,
    unpublished_details: ?Details = null,
    unpublished_class: ?ClassDetails = null,
    tree_due: u64 = 0,
    classes_due: u64 = 0,
    details_due: u64 = 0,
    selected: usize = 0,
    selected_class: usize = 0,
    class_due: bool = false,
    sorts: std.AutoHashMapUnmanaged(usize, Sort) = .empty,
    /// Where enums keep their names, worked out from the first one asked about
    enum_names: ?usize = null,
    enum_names_tried: bool = false,
    /// The class list's gone out at least once, for Show class from Scene
    classes_listed: bool = false,

    // Workbench thread from here down
    filter: [128:0]u8 = @splat(0),
    split: ui.Split = .{ .direction = .down, .ratio = 0.5 },
    class_split: ui.Split = .{ .direction = .across, .ratio = 0.4 },
    class_filter: [128:0]u8 = @splat(0),
    /// What the inspector shows, and the tree's row for it
    picked: usize = 0,
    picked_node: usize = 0,
    picked_function: usize = 0,
    picked_class: usize = 0,
    held_key: u64 = 0,
    held_floats: [4]f64 = undefined,
    held_number: f64 = 0,
    held_integer: i64 = 0,
    gizmo_choice: usize = 1,
    gizmo_world: bool = false,

    /// Not on the game thread, since finding the classes walks every object. Panels and all, or
    /// nothing if this Unreal's missing what it needs.
    pub fn start(self: *Explorer, ue: *const Unreal, world: *const World, loop: *Loop, tools: ?W.FreeCamera) !void {
        self.* = .{ .ue = ue, .world = world, .loop = loop, .tools = tools };
        self.found = try find(ue);
        errdefer self.removeTabs();
        self.tab = try sdk.workbench.addHolder(&self.holder);
        self.scene_panel = try sdk.workbench.addPanel(self, drawScene, .{ .title = "Scene", .kind = "scene", .parent = "unreal" });
        self.classes_panel = try sdk.workbench.addPanel(self, drawClasses, .{ .title = "Classes", .kind = "classes", .parent = "unreal" });
        // No gizmo without the overlay, but the panels are still fine
        self.gizmo = sdk.overlay.addGizmo() catch null;
        if (self.gizmo) |g| g.setTool(.move);
    }

    fn removeTabs(self: *Explorer) void {
        if (self.scene_panel) |p| p.remove();
        if (self.classes_panel) |p| p.remove();
        if (self.tab) |t| t.remove();
        self.scene_panel = null;
        self.classes_panel = null;
        self.tab = null;
    }

    /// Waits for a draw in flight. Call it before the game thread's ticks stop for good.
    pub fn stop(self: *Explorer) void {
        if (self.gizmo) |g| g.remove();
        self.gizmo = null;
        self.removeTabs();
        if (self.walk) |*w| w.deinit();
        self.walk = null;
        self.sorts.deinit(gpa);
        self.tree.deinit();
        self.details.deinit();
        self.classes.deinit();
        self.class_details.deinit();
        self.actions.deinit();
    }

    fn find(ue: *const Unreal) !Found {
        const engine_names = [_][]const u8{ "Actor", "ActorComponent", "SceneComponent", "Level", "World" };
        var engine: [engine_names.len]usize = undefined;
        ue.findIn("/Script/Engine", &engine_names, &engine);
        const core_names = [_][]const u8{ "ScriptStruct", "Enum" };
        var core: [core_names.len]usize = undefined;
        ue.findIn("/Script/CoreUObject", &core_names, &core);
        for (engine_names, engine) |n, f| if (f == 0) {
            log.warn("No Scene panel, since this Unreal's missing {s}", .{n});
            return error.MissingClass;
        };
        const actor, const component, const scene, const level, const world = engine;
        return .{
            .actor = actor,
            .component = component,
            .scene = scene,
            .level = level,
            .class = ue.core.class,
            .script_struct = core[0],
            .enumeration = core[1],
            .world_levels = ue.offsetOf(world, "Levels"),
            .root_component = ue.offsetOf(actor, "RootComponent"),
            .attach_parent = ue.offsetOf(scene, "AttachParent"),
            .hidden = bitOf(ue, actor, "bHidden"),
            .actor_location = callOf(ue, actor, "K2_GetActorLocation", "ReturnValue"),
            .component_location = callOf(ue, scene, "K2_GetComponentLocation", "ReturnValue"),
            .set_hidden = callOf(ue, actor, "SetActorHiddenInGame", "bNewHidden"),
            .get_rotation = callOf(ue, actor, "K2_GetActorRotation", "ReturnValue"),
            .get_scale = callOf(ue, actor, "GetActorScale3D", "ReturnValue"),
            .set_location = withSecond(ue, callOf(ue, actor, "K2_SetActorLocation", "NewLocation"), "bTeleport"),
            .set_rotation = withSecond(ue, callOf(ue, actor, "K2_SetActorRotation", "NewRotation"), "bTeleportPhysics"),
            .set_scale = callOf(ue, actor, "SetActorScale3D", "NewScale3D"),
            .mobility = ue.offsetOf(scene, "Mobility"),
            .set_mobility = callOf(ue, scene, "SetMobility", "NewMobility"),
        };
    }

    // The game thread

    /// Game thread, once a tick.
    pub fn tick(self: *Explorer) void {
        for (self.actions.drain()) |a| self.apply(a);
        self.tickGizmo();
        const scene_open = if (self.scene_panel) |p| p.isOpen() else false;
        const classes_open = if (self.classes_panel) |p| p.isOpen() else false;
        if (!scene_open and !classes_open) return;
        const now = sdk.timing.now();

        if (self.unpublished_tree) |t| {
            if (self.tree.publish(t)) self.unpublished_tree = null;
        } else if (self.unpublished_classes) |c| {
            if (self.classes.publish(c)) self.unpublished_classes = null;
        } else if (self.walk) |*w| {
            self.walkSome(w, scene_open, classes_open, now);
        } else if ((scene_open and now >= self.tree_due) or (classes_open and now >= self.classes_due)) {
            self.startWalk();
        }

        if (self.unpublished_details) |d| {
            if (self.details.publish(d)) self.unpublished_details = null;
        } else if (scene_open and self.selected != 0 and now >= self.details_due) {
            self.details_due = now + details_every_ns;
            const d = self.readDetails(self.details.next(), self.selected);
            if (!self.details.publish(d)) self.unpublished_details = d;
        }

        if (self.unpublished_class) |c| {
            if (self.class_details.publish(c)) self.unpublished_class = null;
        } else if (classes_open and self.class_due) {
            self.class_due = false;
            const c = self.readClass(self.class_details.next(), self.selected_class);
            if (!self.class_details.publish(c)) self.unpublished_class = c;
        }
    }

    fn startWalk(self: *Explorer) void {
        const world = self.world.world() orelse return;
        var w: Walk = .{ .count = self.ue.objects.count(), .world = world };
        // The world's levels, streaming ones too, whose outers are worlds of their own
        if (self.found.world_levels) |off| {
            const arr = self.ue.mem.read(TArray, world + off) orelse std.mem.zeroes(TArray);
            const n: usize = @intCast(std.math.clamp(arr.num, 0, 512));
            for (0..n) |i| {
                const level = self.ue.mem.ptr(arr.data + i * @sizeOf(usize)) orelse continue;
                w.levels.put(gpa, level, {}) catch {};
            }
        }
        if (self.ue.mem.ptr(world + self.world.off.persistent_level)) |level| w.levels.put(gpa, level, {}) catch {};
        self.walk = w;
    }

    /// The object at `i`, read plainly. On the game thread every object in the array is alive.
    fn objectAt(self: *const Explorer, i: usize) usize {
        return self.ue.objects.getPlain(i);
    }

    fn walkSome(self: *Explorer, w: *Walk, scene_open: bool, classes_open: bool, now: u64) void {
        const started = sdk.timing.now();
        while (w.at < w.count) : (w.at += 1) {
            if (w.at % 256 == 0 and sdk.timing.now() - started > walk_budget_ns) return;
            const obj = self.objectAt(w.at);
            if (obj == 0) continue;
            if (plain(u32, obj + object.flags) & template_flags != 0) continue;
            const class = plain(usize, obj + object.class);
            const outer = plain(usize, obj + self.ue.outerAt());
            const raw: Raw = .{ .object = obj, .outer = outer, .class = class };
            switch (self.sortOf(class)) {
                .actor => if (w.levels.contains(outer) and w.actors.items.len < max_actors) w.actors.append(gpa, raw) catch {},
                .component => if (w.comps.items.len < max_components) w.comps.append(gpa, raw) catch {},
                .class, .script_struct, .enumeration => if (w.classes.items.len < max_classes) w.classes.append(gpa, raw) catch {},
                .level, .other => {},
            }
        }
        if (scene_open) {
            self.tree_due = now + tree_every_ns;
            const t = self.link(w);
            if (!self.tree.publish(t)) self.unpublished_tree = t;
        }
        if (classes_open or !self.classes_listed) {
            self.classes_listed = true;
            self.classes_due = now + classes_every_ns;
            const c = self.listClasses(w);
            if (!self.classes.publish(c)) self.unpublished_classes = c;
        }
        w.deinit();
        self.walk = null;
    }

    /// What an object of `class` is, through its supers, remembered for each class.
    fn sortOf(self: *Explorer, class: usize) Sort {
        if (self.sorts.get(class)) |s| return s;
        const f = &self.found;
        var sort: Sort = .other;
        var at: ?usize = class;
        var depth: usize = 0;
        while (at) |c| : (at = self.ue.superOf(c)) {
            depth += 1;
            if (depth > 64) break;
            if (c == f.actor) {
                sort = .actor;
            } else if (c == f.component) {
                sort = .component;
            } else if (c == f.level) {
                sort = .level;
            } else if (c == f.class) {
                sort = .class;
            } else if (c == f.script_struct) {
                sort = .script_struct;
            } else if (c == f.enumeration) {
                sort = .enumeration;
            } else continue;
            break;
        }
        self.sorts.put(gpa, class, sort) catch {};
        return sort;
    }

    /// Levels first, each actor under its level or what it's attached to, children by name.
    fn link(self: *Explorer, w: *Walk) Tree {
        const a = self.tree.next();
        var nodes: std.ArrayList(Node) = .empty;
        var at_of: std.AutoHashMapUnmanaged(usize, i32) = .empty;
        defer at_of.deinit(gpa);
        var buf: [256]u8 = undefined;
        var class_buf: [256]u8 = undefined;

        var levels = w.levels.keyIterator();
        while (levels.next()) |level| {
            const owner = self.ue.outerOf(level.*) orelse level.*;
            const name = std.fmt.allocPrint(a, "{s}", .{self.ue.nameOf(owner, &buf) orelse "?"}) catch "?";
            at_of.put(gpa, level.*, @intCast(nodes.items.len)) catch {};
            nodes.append(a, .{ .object = level.*, .level = true, .name = name, .class = "Level", .hidden = false }) catch {};
        }
        for (w.actors.items) |r| {
            at_of.put(gpa, r.object, @intCast(nodes.items.len)) catch {};
            nodes.append(a, .{
                .object = r.object,
                .level = false,
                .name = a.dupe(u8, self.ue.nameOf(r.object, &buf) orelse "?") catch "?",
                .class = a.dupe(u8, self.ue.nameOf(r.class, &class_buf) orelse "?") catch "?",
                .hidden = self.isHidden(r.object),
                .parent = at_of.get(r.outer) orelse -1,
            }) catch break;
        }
        // Attached actors under what they're attached to
        for (nodes.items) |*n| {
            if (n.level) continue;
            if (self.attachedTo(n.object)) |owner| if (at_of.get(owner)) |p| {
                if (!nodes.items[@intCast(p)].level) n.parent = p;
            };
        }

        // Components, grouped by their actor
        var comps: std.ArrayList(struct { owner: i32, comp: Comp }) = .empty;
        defer comps.deinit(gpa);
        for (w.comps.items) |r| {
            const owner = at_of.get(r.outer) orelse continue;
            if (nodes.items[@intCast(owner)].level) continue;
            comps.append(gpa, .{ .owner = owner, .comp = .{
                .object = r.object,
                .name = a.dupe(u8, self.ue.nameOf(r.object, &buf) orelse "?") catch "?",
                .class = a.dupe(u8, self.ue.nameOf(r.class, &class_buf) orelse "?") catch "?",
            } }) catch break;
        }
        std.mem.sort(@TypeOf(comps.items[0]), comps.items, {}, struct {
            fn less(_: void, x: @TypeOf(comps.items[0]), y: @TypeOf(comps.items[0])) bool {
                if (x.owner != y.owner) return x.owner < y.owner;
                return std.mem.lessThan(u8, x.comp.name, y.comp.name);
            }
        }.less);
        const flat: []Comp = a.alloc(Comp, comps.items.len) catch &.{};
        for (comps.items, 0..) |c, i| {
            if (i >= flat.len) break;
            flat[i] = c.comp;
            const n = &nodes.items[@intCast(c.owner)];
            if (n.comp_count == 0) n.comp_start = @intCast(i);
            n.comp_count += 1;
        }

        // Children in name order, levels first at the top
        const order = a.alloc(u32, nodes.items.len) catch return .{ .nodes = nodes.items, .comps = flat, .first_root = -1, .cut = true };
        for (order, 0..) |*o, i| o.* = @intCast(i);
        std.mem.sort(u32, order, nodes.items, struct {
            fn less(ns: []Node, x: u32, y: u32) bool {
                if (ns[x].parent != ns[y].parent) return ns[x].parent < ns[y].parent;
                return std.ascii.lessThanIgnoreCase(ns[x].name, ns[y].name);
            }
        }.less);
        var first_root: i32 = -1;
        var i = order.len;
        while (i > 0) {
            i -= 1;
            const at: i32 = @intCast(order[i]);
            const n = &nodes.items[order[i]];
            if (n.parent >= 0) {
                const p = &nodes.items[@intCast(n.parent)];
                n.next = p.first_child;
                p.first_child = at;
            } else {
                n.next = first_root;
                first_root = at;
            }
        }
        return .{ .nodes = nodes.items, .comps = flat, .first_root = first_root, .cut = w.actors.items.len >= max_actors };
    }

    fn listClasses(self: *Explorer, w: *Walk) ClassList {
        const a = self.classes.next();
        var buf: [256]u8 = undefined;
        const entries = a.alloc(ClassEntry, w.classes.items.len) catch return .{ .entries = &.{} };
        var n: usize = 0;
        for (w.classes.items) |r| {
            const name = self.ue.nameOf(r.object, &buf) orelse continue;
            entries[n] = .{ .class = r.object, .name = a.dupe(u8, name) catch continue, .sort = self.sortOf(r.class) };
            n += 1;
        }
        std.mem.sort(ClassEntry, entries[0..n], {}, struct {
            fn less(_: void, x: ClassEntry, y: ClassEntry) bool {
                return std.ascii.lessThanIgnoreCase(x.name, y.name);
            }
        }.less);
        return .{ .entries = entries[0..n] };
    }

    /// The actor this one's root is attached to, if any.
    fn attachedTo(self: *const Explorer, actor: usize) ?usize {
        const root_off = self.found.root_component orelse return null;
        const parent_off = self.found.attach_parent orelse return null;
        const root = self.ue.mem.ptr(actor + root_off) orelse return null;
        const parent = self.ue.mem.ptr(root + parent_off) orelse return null;
        const owner = self.ue.outerOf(parent) orelse return null;
        return if (owner != actor) owner else null;
    }

    fn isHidden(self: *const Explorer, actor: usize) bool {
        const bit = self.found.hidden orelse return false;
        const byte = self.ue.mem.read(u8, actor + bit.offset) orelse return false;
        return byte & bit.mask != 0;
    }

    /// Still a live object, by being where its index says. For objects the panel's held since.
    fn alive(self: *const Explorer, obj: usize) bool {
        return obj != 0 and self.ue.objects.isObject(obj);
    }

    fn apply(self: *Explorer, action: Action) void {
        switch (action) {
            .select => |obj| {
                self.selected = obj;
                self.details_due = 0;
            },
            .select_class => |class| {
                self.selected_class = class;
                self.class_due = true;
            },
            .find_instance => |class| if (self.alive(class)) {
                const found = self.instanceOf(class) orelse return;
                self.selected = found;
                self.details_due = 0;
                self.found_instance.store(found, .release);
            },
            .set_bytes => |s| if (self.alive(s.object)) {
                sdk.mem.Memory.local.write(s.at, s.bytes[0..s.len]) catch {};
                self.details_due = 0;
            },
            .set_bit => |s| if (self.alive(s.object)) {
                const byte = self.ue.mem.read(u8, s.at) orelse return;
                _ = self.ue.mem.write(u8, s.at, if (s.on) byte | s.mask else byte & ~s.mask);
                self.details_due = 0;
            },
            .set_hidden => |s| if (self.alive(s.object)) {
                const c = self.found.set_hidden orelse return;
                var params: [16]u8 align(16) = @splat(0);
                if (c.size > params.len) return;
                params[c.param] = @intFromBool(s.on);
                self.loop.call(s.object, c.function, params[0..c.size]);
                self.details_due = 0;
                self.tree_due = 0;
            },
            .set_transform => |s| if (self.alive(s.object)) self.setTransform(s.object, s.part, s.value),
            .call => |s| if (self.alive(s.object) and self.alive(s.function)) {
                var params: [0]u8 = .{};
                self.loop.call(s.object, s.function, &params);
                self.details_due = 0;
            },
            .focus => |obj| if (self.alive(obj)) {
                const tools = self.tools orelse return;
                const at = self.locationOf(obj) orelse return;
                tools.focus(at);
            },
            .refresh => {
                self.tree_due = 0;
                self.classes_due = 0;
                self.details_due = 0;
                self.class_due = true;
            },
        }
    }

    fn setTransform(self: *Explorer, actor: usize, part: TransformPart, value: [3]f64) void {
        const c = switch (part) {
            .location => self.found.set_location,
            .rotation => self.found.set_rotation,
            .scale => self.found.set_scale,
        } orelse return;
        var params: [max_params]u8 align(16) = @splat(0);
        if (c.size > params.len) return;
        self.makeMovable(actor);
        self.writeVector(&params, c.param, value);
        // Straight there, rather than swept or pushed by physics
        if (c.second) |o| params[o] = 1;
        self.loop.call(actor, c.function, params[0..c.size]);
        self.details_due = 0;
    }

    /// Shows the gizmo on the picked actor while Scene's open with a tool picked, moves the actor
    /// where it's dragged, and keeps it placed where the actor is.
    fn tickGizmo(self: *Explorer) void {
        const g = self.gizmo orelse return;
        const tool = self.gizmo_tool.load(.monotonic);
        const actor = self.gizmo_actor.load(.monotonic);
        if (tool == 0 or !self.sceneOpen() or !self.isActor(actor)) {
            if (self.gizmo_shown) g.hide();
            self.gizmo_shown = false;
            return;
        }
        if (!self.gizmo_shown) g.show();
        self.gizmo_shown = true;
        // Only what the tool changes, so moving it never nudges its rotation or scale
        if (g.moved()) |m| {
            const part, const value = partOf(m, tool);
            self.setTransform(actor, part, value);
        }
        g.place(matrixOf(self.transformOf(actor) orelse return));
    }

    /// Only actors have the functions it's read and moved with, not levels.
    fn isActor(self: *Explorer, obj: usize) bool {
        if (!self.alive(obj)) return false;
        const class = self.ue.classOf(obj) orelse return false;
        return self.sortOf(class) == .actor;
    }

    /// Unreal won't move a static or stationary actor, so its root's made movable first, as the
    /// editor does. What's attached to it follows.
    fn makeMovable(self: *Explorer, actor: usize) void {
        const movable = 2;
        const root_at = self.found.root_component orelse return;
        const mobility_at = self.found.mobility orelse return;
        const c = self.found.set_mobility orelse return;
        const root = self.ue.mem.ptr(actor + root_at) orelse return;
        if ((self.ue.mem.read(u8, root + mobility_at) orelse return) == movable) return;
        var params: [16]u8 align(16) = @splat(0);
        if (c.size > params.len) return;
        params[c.param] = movable;
        self.loop.call(root, c.function, params[0..c.size]);
        var buf: [256]u8 = undefined;
        log.info("Made {s} movable, so it can be moved", .{self.ue.nameOf(actor, &buf) orelse "it"});
    }

    /// An actor's location, rotation and scale, through its own functions.
    fn transformOf(self: *Explorer, actor: usize) ?[3][3]f64 {
        const calls = [_]?Call{ self.found.actor_location, self.found.get_rotation, self.found.get_scale };
        var out: [3][3]f64 = undefined;
        for (calls, &out) |maybe, *v| {
            const c = maybe orelse return null;
            var params: [max_params]u8 align(16) = @splat(0);
            if (c.size > params.len) return null;
            self.loop.call(actor, c.function, params[0..c.size]);
            v.* = self.readVector(&params, c.param);
        }
        return out;
    }

    /// Three floats, or doubles in UE5, the way vectors and rotators are kept.
    fn readVector(self: *const Explorer, params: []const u8, at: usize) [3]f64 {
        if (self.ue.layout.doubles) return std.mem.bytesToValue([3]f64, params[at..][0..24]);
        const v = std.mem.bytesToValue([3]f32, params[at..][0..12]);
        return .{ v[0], v[1], v[2] };
    }

    fn writeVector(self: *const Explorer, params: []u8, at: usize, v: [3]f64) void {
        if (self.ue.layout.doubles) {
            @memcpy(params[at..][0..24], std.mem.asBytes(&v));
        } else {
            const f = [3]f32{ @floatCast(v[0]), @floatCast(v[1]), @floatCast(v[2]) };
            @memcpy(params[at..][0..12], std.mem.asBytes(&f));
        }
    }

    /// The first live one of `class` or what comes from it. Goes through every object.
    fn instanceOf(self: *Explorer, class: usize) ?usize {
        return self.ue.liveInstanceOf(class);
    }

    /// Where an actor or scene component is, in the world.
    fn locationOf(self: *Explorer, obj: usize) ?Vec3 {
        const class = self.ue.classOf(obj) orelse return null;
        const c = switch (self.sortOf(class)) {
            .actor => self.found.actor_location,
            .component => self.found.component_location,
            else => null,
        } orelse return null;
        var params: [32]u8 align(16) = @splat(0);
        if (c.size > params.len) return null;
        self.loop.call(obj, c.function, params[0..c.size]);
        const at = @intFromPtr(&params) + c.param;
        if (self.ue.layout.doubles) {
            const v = plain([3]f64, at);
            return .{ .x = @floatCast(v[0]), .y = @floatCast(v[1]), .z = @floatCast(v[2]) };
        }
        const v = plain([3]f32, at);
        return .{ .x = v[0], .y = v[1], .z = v[2] };
    }

    // Reading an object's properties, on the game thread

    const Reader = struct {
        ex: *Explorer,
        a: std.mem.Allocator,
        props: std.ArrayList(Prop) = .empty,
        buf: [256]u8 = undefined,

        fn full(r: *const Reader) bool {
            return r.props.items.len >= max_props;
        }

        /// A struct's or class's own properties, at `base`.
        fn fields(r: *Reader, strct: usize, base: usize, depth: u8) void {
            const ue = r.ex.ue;
            var field = ue.firstField(strct);
            var n: usize = 0;
            while (field) |f| : (field = ue.nextField(f)) {
                n += 1;
                if (n > 4096 or r.full()) return;
                r.property(f, base, depth);
            }
        }

        /// A struct's properties with its supers', for nested structs.
        fn allFields(r: *Reader, strct: usize, base: usize, depth: u8) void {
            var chain: [16]usize = undefined;
            var len: usize = 0;
            var at: ?usize = strct;
            while (at) |s| : (at = r.ex.ue.superOf(s)) {
                if (len == chain.len) break;
                chain[len] = s;
                len += 1;
            }
            // Base struct's first, the way they're laid out
            var i = len;
            while (i > 0) {
                i -= 1;
                r.fields(chain[i], base, depth);
            }
        }

        fn property(r: *Reader, field: usize, base: usize, depth: u8) void {
            const ue = r.ex.ue;
            var kind_buf: [128]u8 = undefined;
            const kind_name = ue.fieldKind(field, &kind_buf) orelse return;
            if (!std.mem.endsWith(u8, kind_name, "Property")) return;
            const p = ue.property(field) orelse return;
            if (p.offset < 0 or p.size <= 0) return;
            const name = r.a.dupe(u8, ue.fieldName(field, &r.buf) orelse "?") catch return;
            const at = base + @as(usize, @intCast(p.offset));
            const size: u8 = @intCast(@min(p.size, 255));
            const kind_text = r.a.dupe(u8, kind_name) catch "";
            var prop: Prop = .{ .name = name, .type = kind_text, .kind = .other, .depth = depth, .at = at, .size = size, .value = .none };

            if (plainKind(kind_name)) |k| {
                prop.kind = k;
                prop.value = r.ex.readNumber(at, k) orelse return;
            } else if (std.mem.eql(u8, kind_name, "BoolProperty")) {
                const info = ue.mem.read([4]u8, field + ue.layout.property_end) orelse return;
                prop.kind = .flag;
                prop.at = at + info[1];
                prop.mask = info[3];
                prop.size = 1;
                const byte = ue.mem.read(u8, prop.at) orelse return;
                prop.value = .{ .flag = byte & prop.mask != 0 };
            } else if (std.mem.eql(u8, kind_name, "ByteProperty") or std.mem.eql(u8, kind_name, "EnumProperty")) {
                const is_enum_prop = kind_name[0] == 'E';
                const enumeration = if (is_enum_prop) ue.mem.ptr(field + ue.layout.property_end + @sizeOf(usize)) else p.type;
                const v = r.ex.readNumber(at, switch (size) {
                    1 => .u8,
                    2 => .u16,
                    4 => .i32,
                    else => .i64,
                }) orelse return;
                prop.value = v;
                if (enumeration) |e| {
                    prop.kind = .enumeration;
                    prop.type = r.a.dupe(u8, ue.nameOf(e, &r.buf) orelse "enum") catch "enum";
                    prop.label = r.ex.enumLabel(r.a, e, v.integer);
                } else prop.kind = .u8;
            } else if (std.mem.eql(u8, kind_name, "NameProperty")) {
                prop.kind = .name;
                prop.value = .{ .text = r.a.dupe(u8, ue.fname(at, &r.buf) orelse "") catch "" };
            } else if (std.mem.eql(u8, kind_name, "StrProperty")) {
                prop.kind = .text;
                prop.value = .{ .text = r.ex.readString(r.a, at) };
            } else if (std.mem.eql(u8, kind_name, "ObjectProperty") or std.mem.eql(u8, kind_name, "ClassProperty") or std.mem.eql(u8, kind_name, "ObjectPtrProperty")) {
                prop.kind = .object;
                const target = ue.mem.read(usize, at) orelse 0;
                prop.value = .{ .object = target };
                if (p.type) |t| prop.type = r.a.dupe(u8, ue.nameOf(t, &r.buf) orelse kind_text) catch kind_text;
                prop.label = r.ex.objectLabel(r.a, target);
            } else if (std.mem.eql(u8, kind_name, "WeakObjectProperty")) {
                prop.kind = .object;
                const index = ue.mem.read(i32, at) orelse -1;
                const target = if (index >= 0) ue.objects.get(@intCast(index)) orelse 0 else 0;
                prop.value = .{ .object = target };
                prop.label = r.ex.objectLabel(r.a, target);
            } else if (std.mem.eql(u8, kind_name, "StructProperty")) {
                const strct = p.type orelse return;
                const struct_name = ue.nameOf(strct, &r.buf) orelse "?";
                prop.type = r.a.dupe(u8, struct_name) catch "";
                if (floatsOf(struct_name, size)) |f| {
                    prop.kind = .floats;
                    prop.value = r.ex.readFloats(at, f.n, f.elem) orelse return;
                } else {
                    prop.kind = .structure;
                    r.props.append(r.a, prop) catch return;
                    if (depth < max_depth) r.allFields(strct, at, depth + 1);
                    return;
                }
            } else if (std.mem.eql(u8, kind_name, "ArrayProperty")) {
                prop.kind = .array;
                const arr = ue.mem.read(TArray, at) orelse return;
                const count: u32 = @bitCast(arr.num);
                prop.label = std.fmt.allocPrint(r.a, "{d} items", .{count}) catch "";
                r.props.append(r.a, prop) catch return;
                if (depth < max_depth and count > 0 and count < 1 << 24) r.elements(field, arr.data, @min(count, max_elements), depth + 1);
                return;
            } else if (std.mem.eql(u8, kind_name, "TextProperty")) {
                prop.label = "(text)";
            } else {
                prop.label = "";
            }
            r.props.append(r.a, prop) catch {};
        }

        /// An array's first few, when they're plain enough to show on a line each.
        fn elements(r: *Reader, field: usize, data: usize, count: u32, depth: u8) void {
            const ue = r.ex.ue;
            const inner = ue.mem.ptr(field + ue.layout.property_end) orelse return;
            var kind_buf: [128]u8 = undefined;
            const inner_kind = ue.fieldKind(inner, &kind_buf) orelse return;
            const p = ue.property(inner) orelse return;
            if (p.size <= 0) return;
            const size: usize = @intCast(p.size);
            const k = plainKind(inner_kind);
            const is_object = std.mem.eql(u8, inner_kind, "ObjectProperty") or std.mem.eql(u8, inner_kind, "ObjectPtrProperty");
            const is_name = std.mem.eql(u8, inner_kind, "NameProperty");
            const is_string = std.mem.eql(u8, inner_kind, "StrProperty");
            if (k == null and !is_object and !is_name and !is_string) return;
            for (0..count) |i| {
                if (r.full()) return;
                const at = data + i * size;
                const name = std.fmt.allocPrint(r.a, "[{d}]", .{i}) catch return;
                var prop: Prop = .{ .name = name, .type = r.a.dupe(u8, inner_kind) catch "", .kind = .other, .depth = depth, .at = at, .size = @intCast(@min(size, 255)), .value = .none };
                if (k) |kind| {
                    prop.kind = kind;
                    prop.value = r.ex.readNumber(at, kind) orelse continue;
                } else if (is_object) {
                    prop.kind = .object;
                    const target = ue.mem.read(usize, at) orelse 0;
                    prop.value = .{ .object = target };
                    prop.label = r.ex.objectLabel(r.a, target);
                } else if (is_name) {
                    prop.kind = .name;
                    prop.value = .{ .text = r.a.dupe(u8, ue.fname(at, &r.buf) orelse "") catch "" };
                } else {
                    prop.kind = .text;
                    prop.value = .{ .text = r.ex.readString(r.a, at) };
                }
                r.props.append(r.a, prop) catch return;
            }
        }
    };

    fn readDetails(self: *Explorer, a: std.mem.Allocator, obj: usize) Details {
        if (!self.alive(obj)) return .{ .object = obj, .gone = true };
        var buf: [512]u8 = undefined;
        const class = self.ue.classOf(obj) orelse return .{ .object = obj, .gone = true };
        var d: Details = .{
            .object = obj,
            .gone = false,
            .name = a.dupe(u8, self.ue.nameOf(obj, &buf) orelse "?") catch "?",
            .class_name = a.dupe(u8, self.ue.nameOf(class, &buf) orelse "?") catch "?",
            .class = class,
            .path = a.dupe(u8, self.ue.pathOf(obj, &buf) orelse "") catch "",
        };
        d.actor = self.sortOf(class) == .actor;
        if (d.actor and self.found.hidden != null) d.hidden = self.isHidden(obj);
        if (d.actor) d.transform = self.transformOf(obj);

        var r: Reader = .{ .ex = self, .a = a };
        var sections: std.ArrayList(Section) = .empty;
        var at: ?usize = class;
        var depth: usize = 0;
        // Its own class first, then where they come from
        while (at) |c| : (at = self.ue.superOf(c)) {
            depth += 1;
            if (depth > 64 or r.full()) break;
            const first: u32 = @intCast(r.props.items.len);
            r.fields(c, obj, 0);
            const count: u32 = @intCast(r.props.items.len - first);
            if (count == 0) continue;
            sections.append(a, .{ .name = a.dupe(u8, self.ue.nameOf(c, &buf) orelse "?") catch "?", .first = first, .count = count }) catch break;
        }
        d.sections = sections.items;
        d.props = r.props.items;
        d.functions = self.functionsOf(a, class, true);
        return d;
    }

    /// Its functions, and its supers' too if `inherited`.
    fn functionsOf(self: *Explorer, a: std.mem.Allocator, class: usize, inherited: bool) []const Func {
        const ue = self.ue;
        var out: std.ArrayList(Func) = .empty;
        var buf: [256]u8 = undefined;
        var class_buf: [256]u8 = undefined;
        const flags_at = ue.functionFlagsOffset();
        var at: ?usize = class;
        var depth: usize = 0;
        while (at) |c| : (at = ue.superOf(c)) {
            depth += 1;
            if (depth > 64) break;
            const class_name = a.dupe(u8, ue.nameOf(c, &class_buf) orelse "?") catch "?";
            var field = ue.firstFunction(c);
            var n: usize = 0;
            while (field) |f| : (field = ue.mem.ptr(f + ue.layout.field_next)) {
                n += 1;
                if (n > 8192 or out.items.len >= max_functions) break;
                // Before 4.25 properties are in the same list
                const kind = ue.classNameOf(f, &buf) orelse continue;
                if (!std.mem.eql(u8, kind, "Function")) continue;
                const flags: u32 = if (flags_at) |o| ue.mem.read(u32, f + o) orelse 0 else 0;
                out.append(a, .{
                    .name = a.dupe(u8, ue.nameOf(f, &buf) orelse "?") catch "?",
                    .function = f,
                    .class = class_name,
                    .params = @intCast(@max(ue.structSize(f) orelse 0, 0)),
                    .static = flags & 0x2000 != 0,
                }) catch break;
            }
            if (!inherited) break;
        }
        return out.items;
    }

    fn readClass(self: *Explorer, a: std.mem.Allocator, class: usize) ClassDetails {
        if (!self.alive(class)) return .{ .class = class };
        const ue = self.ue;
        var buf: [512]u8 = undefined;
        var d: ClassDetails = .{
            .class = class,
            .name = a.dupe(u8, ue.nameOf(class, &buf) orelse "?") catch "?",
            .path = a.dupe(u8, ue.pathOf(class, &buf) orelse "") catch "",
            .sort = if (ue.classOf(class)) |meta| self.sortOf(meta) else .other,
            .size = ue.structSize(class) orelse 0,
        };
        var supers: std.ArrayList(ClassEntry) = .empty;
        var at = ue.superOf(class);
        var depth: usize = 0;
        while (at) |s| : (at = ue.superOf(s)) {
            depth += 1;
            if (depth > 64) break;
            supers.append(a, .{ .class = s, .name = a.dupe(u8, ue.nameOf(s, &buf) orelse "?") catch "?", .sort = d.sort }) catch break;
        }
        d.supers = supers.items;
        if (d.sort == .enumeration) {
            d.fields = self.enumFields(a, class);
            return d;
        }
        var fields: std.ArrayList(Field) = .empty;
        var kind_buf: [128]u8 = undefined;
        var field = ue.firstField(class);
        var n: usize = 0;
        while (field) |f| : (field = ue.nextField(f)) {
            n += 1;
            if (n > 4096) break;
            const kind = ue.fieldKind(f, &kind_buf) orelse continue;
            if (!std.mem.endsWith(u8, kind, "Property")) continue;
            const p = ue.property(f) orelse continue;
            const type_name = if (p.type) |t| ue.nameOf(t, &buf) orelse kind else kind;
            fields.append(a, .{
                .name = a.dupe(u8, ue.fieldName(f, &buf) orelse "?") catch "?",
                .type = a.dupe(u8, type_name) catch "",
                .offset = p.offset,
                .size = p.size * @max(p.count, 1),
            }) catch break;
        }
        d.fields = fields.items;
        if (d.sort == .class) d.functions = self.functionsOf(a, class, false);
        return d;
    }

    /// An enum's names and values, as fields.
    fn enumFields(self: *Explorer, a: std.mem.Allocator, enumeration: usize) []const Field {
        const off = self.enumNamesAt(enumeration) orelse return &.{};
        const arr = self.ue.mem.read(TArray, enumeration + off) orelse return &.{};
        const n: usize = @intCast(std.math.clamp(arr.num, 0, 1024));
        const out = a.alloc(Field, n) catch return &.{};
        var buf: [256]u8 = undefined;
        for (out, 0..) |*f, i| {
            const value = self.ue.mem.read(i64, arr.data + i * self.enumPair() + self.enumValueAt()) orelse 0;
            f.* = .{ .name = a.dupe(u8, shortEnum(self.ue.fname(arr.data + i * self.enumPair(), &buf) orelse "?")) catch "?", .type = "", .offset = @truncate(value), .size = 0 };
        }
        return out;
    }

    fn readNumber(self: *const Explorer, at: usize, kind: Kind) ?Value {
        const mem = self.ue.mem;
        return switch (kind) {
            .i8 => .{ .integer = mem.read(i8, at) orelse return null },
            .u8 => .{ .integer = mem.read(u8, at) orelse return null },
            .i16 => .{ .integer = mem.read(i16, at) orelse return null },
            .u16 => .{ .integer = mem.read(u16, at) orelse return null },
            .i32 => .{ .integer = mem.read(i32, at) orelse return null },
            .u32 => .{ .integer = mem.read(u32, at) orelse return null },
            .i64, .u64 => .{ .integer = mem.read(i64, at) orelse return null },
            .f32 => .{ .number = mem.read(f32, at) orelse return null },
            .f64 => .{ .number = mem.read(f64, at) orelse return null },
            else => null,
        };
    }

    fn readFloats(self: *const Explorer, at: usize, n: u8, elem: u8) ?Value {
        var v: [4]f64 = @splat(0);
        for (0..n) |i| {
            v[i] = if (elem == 8)
                self.ue.mem.read(f64, at + i * 8) orelse return null
            else
                self.ue.mem.read(f32, at + i * 4) orelse return null;
        }
        return .{ .floats = .{ .v = v, .n = n, .elem = elem } };
    }

    /// An FString: its UTF-16 and length, up to 255 characters.
    fn readString(self: *const Explorer, a: std.mem.Allocator, at: usize) []const u8 {
        const arr = self.ue.mem.read(TArray, at) orelse return "";
        const num = arr.num;
        if (arr.data == 0 or num <= 1) return "";
        const n: usize = @min(@as(usize, @intCast(num - 1)), 255);
        var units: [255]u16 = undefined;
        if (!self.ue.mem.bytes(arr.data, std.mem.sliceAsBytes(units[0..n]))) return "";
        return std.unicode.utf16LeToUtf8Alloc(a, units[0..n]) catch "";
    }

    fn objectLabel(self: *const Explorer, a: std.mem.Allocator, target: usize) []const u8 {
        if (target == 0) return "None";
        var buf: [256]u8 = undefined;
        var class_buf: [256]u8 = undefined;
        if (!self.ue.objects.isObject(target)) return std.fmt.allocPrint(a, "0x{x}", .{target}) catch "";
        return std.fmt.allocPrint(a, "{s} ({s})", .{ self.ue.nameOf(target, &buf) orelse "?", self.ue.classNameOf(target, &class_buf) orelse "?" }) catch "";
    }

    fn enumLabel(self: *Explorer, a: std.mem.Allocator, enumeration: usize, value: i64) []const u8 {
        const off = self.enumNamesAt(enumeration) orelse return "";
        const arr = self.ue.mem.read(TArray, enumeration + off) orelse return "";
        const n: usize = @intCast(std.math.clamp(arr.num, 0, 1024));
        var buf: [256]u8 = undefined;
        for (0..n) |i| {
            if (self.ue.mem.read(i64, arr.data + i * self.enumPair() + self.enumValueAt()) != value) continue;
            return a.dupe(u8, shortEnum(self.ue.fname(arr.data + i * self.enumPair(), &buf) orelse "")) catch "";
        }
        return "";
    }

    /// Where a value is in one of UEnum's name and value pairs, after the name.
    fn enumValueAt(self: *const Explorer) usize {
        return std.mem.alignForward(usize, self.ue.name_size, 8);
    }

    fn enumPair(self: *const Explorer) usize {
        return self.enumValueAt() + 8;
    }

    /// Where UEnum keeps `Names`, its pairs of name and value, worked out the first time: a
    /// TArray after UField, whose first name's text and value look right.
    fn enumNamesAt(self: *Explorer, enumeration: usize) ?usize {
        if (self.enum_names_tried) return self.enum_names;
        self.enum_names_tried = true;
        const ue = self.ue;
        const after_field = ue.layout.field_next + @sizeOf(usize);
        var buf: [256]u8 = undefined;
        var o: usize = after_field;
        while (o < after_field + 0x60) : (o += @alignOf(TArray)) {
            const arr = ue.mem.read(TArray, enumeration + o) orelse continue;
            if (arr.num <= 0 or arr.num > arr.max or arr.max > 100_000) continue;
            const text = ue.fname(arr.data, &buf) orelse continue;
            if (text.len == 0) continue;
            const value = ue.mem.read(i64, arr.data + self.enumValueAt()) orelse continue;
            if (value < -1_000_000 or value > 1_000_000) continue;
            self.enum_names = o;
            return o;
        }
        log.info("Can't find where enums keep their names, so enums show as numbers", .{});
        return null;
    }

    // The Workbench's thread

    /// Any thread.
    fn sceneOpen(self: *const Explorer) bool {
        return if (self.scene_panel) |p| p.isOpen() else false;
    }

    // The Workbench's thread

    fn drawScene(self: *Explorer) void {
        const jumped = self.found_instance.swap(0, .acq_rel);
        if (jumped != 0) {
            self.picked = jumped;
            self.picked_node = jumped;
            if (self.gizmo) |g| g.show();
        }
        self.gizmo_actor.store(self.picked_node, .monotonic);
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
        _ = ui.inputTextHint("##filter", "Filter by name or class", &self.filter);
        const reading = self.tree.read() orelse {
            ui.sameLine();
            ui.textDisabled("Asking Unreal...", .{});
            return;
        };
        defer reading.end();
        const tree = reading.value;
        ui.sameLine();
        ui.textDisabled("{d} actors{s}", .{ tree.nodes.len, if (tree.cut) ", and more" else "" });

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
        if (n.level) flags |= ui.c.ImGuiTreeNodeFlags_DefaultOpen;
        if (n.object == self.picked_node) flags |= ui.c.ImGuiTreeNodeFlags_Selected;
        if (n.hidden) ui.raw("ImGui_PushStyleColorImVec4")(ui.c.ImGuiCol_Text, ui.raw("ImGui_GetStyleColorVec4")(ui.c.ImGuiCol_TextDisabled).*);
        const label = if (n.level) ui.format("{s}###{x}", .{ n.name, n.object }) else ui.format("{s}  {s}###{x}", .{ n.name, n.class, n.object });
        const open = ui.raw("ImGui_TreeNodeEx")(ui.str(label), flags);
        if (n.hidden) ui.raw("ImGui_PopStyleColor")();
        if (ui.raw("ImGui_IsItemClicked")() and !ui.raw("ImGui_IsItemToggledOpen")()) self.pick(n.object, n.object);
        if (!open) return;
        defer ui.raw("ImGui_TreePop")();
        var at = n.first_child;
        while (at >= 0) : (at = tree.nodes[@intCast(at)].next) self.drawNode(tree, @intCast(at));
    }

    /// A flat list of what matches, with each one's parent.
    fn drawMatches(self: *Explorer, tree: *const Tree, text: []const u8) void {
        var shown: usize = 0;
        for (tree.nodes) |*n| {
            if (n.level) continue;
            if (std.ascii.findIgnoreCase(n.name, text) == null and std.ascii.findIgnoreCase(n.class, text) == null) continue;
            if (shown == max_matches) {
                ui.textDisabled("And more. Type more of the name to narrow it down.", .{});
                break;
            }
            shown += 1;
            const parent = if (n.parent >= 0) tree.nodes[@intCast(n.parent)].name else "";
            if (ui.selectable(ui.format("{s}  {s}  {s}###{x}", .{ n.name, n.class, parent, n.object }), n.object == self.picked_node)) self.pick(n.object, n.object);
        }
        if (shown == 0) ui.textDisabled("Nothing's called that.", .{});
    }

    fn pick(self: *Explorer, obj: usize, node: usize) void {
        self.picked = obj;
        self.picked_node = node;
        self.picked_function = 0;
        self.actions.push(.{ .select = obj });
        // In front again, even over posing's
        if (self.gizmo) |g| g.show();
    }

    fn treeCommands(self: *Explorer, tree: *const Tree) void {
        var menu = ui.commands("scene", .{});
        defer menu.end();
        const node = self.nodeOf(tree, self.picked_node);
        const actor = if (node) |n| !n.level else false;
        if (menu.item(.{ .label = "Orbit the camera round it", .enabled = actor and self.tools != null, .default = true, .tooltip = "The free camera takes over and orbits where it is" })) self.actions.push(.{ .focus = self.picked_node });
        if (menu.item(.{ .label = "Hide or show", .enabled = actor and self.found.set_hidden != null, .tooltip = "Its SetActorHiddenInGame" })) {
            self.actions.push(.{ .set_hidden = .{ .object = self.picked_node, .on = !(node.?.hidden) } });
        }
        if (menu.item(.{ .label = "Copy", .chord = ui.copy_chord, .enabled = node != null, .tooltip = "It and everything under it, one a line: its name, class, whether it's hidden, and its components" })) {
            if (node) |n| self.copyNode(tree, n);
        }
        if (menu.item(.{ .label = "Show class", .enabled = actor, .tooltip = "Its class, in Classes" })) {
            if (self.details.read()) |d| {
                defer d.end();
                if (d.value.object == self.picked_node) self.showClass(d.value.class);
            }
        }
        menu.separator();
        if (menu.item(.{ .label = "Refresh", .tooltip = "Asks Unreal again now" })) self.actions.push(.refresh);
    }

    fn nodeOf(_: *const Explorer, tree: *const Tree, obj: usize) ?*const Node {
        if (obj == 0) return null;
        for (tree.nodes) |*n| if (n.object == obj) return n;
        return null;
    }

    fn copyNode(self: *Explorer, tree: *const Tree, top: *const Node) void {
        var clip: ui.Clip = .{};
        self.copyLines(&clip, tree, top, 0);
        clip.copy();
    }

    fn copyLines(self: *Explorer, clip: *ui.Clip, tree: *const Tree, n: *const Node, depth: u32) void {
        if (depth > 64) return;
        var comps: [2048]u8 = undefined;
        var w: std.Io.Writer = .fixed(&comps);
        for (tree.comps[n.comp_start..][0..n.comp_count], 0..) |c, i| {
            if (i > 0) w.writeAll(", ") catch break;
            w.writeAll(c.class) catch break;
        }
        clip.line("{s}{s}\t{s}\t{s}\t{s}", .{ indentOf(depth), n.name, n.class, if (n.hidden) "hidden" else "shown", w.buffered() });
        var at = n.first_child;
        while (at >= 0) : (at = tree.nodes[@intCast(at)].next) self.copyLines(clip, tree, &tree.nodes[@intCast(at)], depth + 1);
    }

    fn drawInspector(self: *Explorer) void {
        if (self.picked == 0) return ui.textDisabled("Pick something in the tree to see what's on it.", .{});
        const reading = self.details.read() orelse return ui.textDisabled("Asking Unreal...", .{});
        defer reading.end();
        const d = reading.value;
        if (d.object != self.picked) return ui.textDisabled("Asking Unreal...", .{});
        if (d.gone) return ui.textDisabled("It's gone. The game's destroyed it since.", .{});

        ui.text("{s}", .{d.name});
        ui.sameLine();
        ui.textDisabled("{s}", .{d.class_name});
        if (ui.isItemHovered()) ui.tooltip("{s}", .{d.path});
        if (d.hidden) |hidden| {
            var on = hidden;
            if (ui.checkbox("Hidden in game", &on)) self.actions.push(.{ .set_hidden = .{ .object = d.object, .on = on } });
        }
        if (self.picked != self.picked_node and self.picked_node != 0) {
            if (ui.selectable("Back to the actor", false)) self.pick(self.picked_node, self.picked_node);
        }
        if (d.transform) |tr| if (ui.collapsingHeader("Transform", true)) {
            self.dragTransform(d, "Location", .location, tr[0], 1);
            self.dragTransform(d, "Rotation", .rotation, tr[1], 0.5);
            self.dragTransform(d, "Scale", .scale, tr[2], 0.01);
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
        };
        self.drawComponents(d);
        for (d.sections, 0..) |s, i| {
            const scope = ui.id(@as(i32, @intCast(i)));
            defer scope.end();
            if (!ui.collapsingHeader(ui.format("{s}###section", .{s.name}), i == 0)) continue;
            self.drawProps(d, d.props[s.first..][0..s.count]);
        }
        if (d.functions.len > 0 and ui.collapsingHeader(ui.format("Functions ({d})###functions", .{d.functions.len}), false)) self.drawFunctions(d.functions);
        self.inspectorCommands(d);
    }

    fn dragTransform(self: *Explorer, d: *const Details, label: [:0]const u8, part: TransformPart, value: [3]f64, speed: f32) void {
        const key = std.hash.Wyhash.hash(d.object, label);
        const held = self.held_key == key;
        var v: [3]f32 = undefined;
        for (&v, 0..) |*o, i| o.* = @floatCast(if (held) self.held_floats[i] else value[i]);
        ui.setNextItemWidth(ui.fill);
        const changed = ui.raw("ImGui_DragFloat3Ex")(ui.str(label), @ptrCast(&v), speed, 0, 0, ui.str("%.3f"), 0);
        if (ui.isItemActive()) {
            self.held_key = key;
            for (self.held_floats[0..3], v) |*o, x| o.* = x;
        } else if (held) self.held_key = 0;
        if (part == .rotation and ui.isItemHovered()) ui.tooltip("Pitch, yaw and roll, in degrees", .{});
        if (changed) self.actions.push(.{ .set_transform = .{ .object = d.object, .part = part, .value = .{ v[0], v[1], v[2] } } });
    }

    fn drawComponents(self: *Explorer, d: *const Details) void {
        if (!d.actor) return;
        const reading = self.tree.read() orelse return;
        defer reading.end();
        const tree = reading.value;
        const node = self.nodeOf(tree, d.object) orelse return;
        if (node.comp_count == 0) return;
        if (!ui.collapsingHeader(ui.format("Components ({d})###components", .{node.comp_count}), true)) return;
        for (tree.comps[node.comp_start..][0..node.comp_count]) |c| {
            if (ui.selectable(ui.format("{s}  {s}###{x}", .{ c.name, c.class, c.object }), c.object == self.picked)) {
                self.picked = c.object;
                self.picked_function = 0;
                self.actions.push(.{ .select = c.object });
            }
        }
    }

    fn drawProps(self: *Explorer, d: *const Details, props: []const Prop) void {
        const table = ui.table("props", 2, .{ .borders = true, .resizable = true, .sizing = .stretch_prop }) orelse return;
        defer table.end();
        ui.tableColumnWith("Property", .{ .stretch = true, .width = 2 });
        ui.tableColumnWith("Value", .{ .stretch = true, .width = 3 });
        for (props, 0..) |*p, i| {
            const scope = ui.id(@as(i32, @intCast(i)));
            defer scope.end();
            ui.tableNextRow();
            _ = ui.tableNextColumn();
            ui.text("{s}{s}", .{ indentOf(p.depth), p.name });
            if (ui.isItemHovered()) ui.tooltip("{s}, at +0x{x}", .{ p.type, p.at -% d.object });
            _ = ui.tableNextColumn();
            ui.setNextItemWidth(ui.fill);
            self.drawValue(d, p);
        }
    }

    fn drawValue(self: *Explorer, d: *const Details, p: *const Prop) void {
        const key = std.hash.Wyhash.hash(p.at, p.name);
        const held = self.held_key == key;
        switch (p.value) {
            .none => ui.textDisabled("{s}", .{if (p.label.len > 0) p.label else p.type}),
            .flag => |b| {
                var v = b;
                if (ui.checkbox("##v", &v)) self.actions.push(.{ .set_bit = .{ .object = d.object, .at = p.at, .mask = p.mask, .on = v } });
            },
            .integer => |n| {
                if (p.kind == .enumeration and p.label.len > 0) {
                    ui.textDisabled("{s}", .{p.label});
                    ui.sameLine();
                    ui.setNextItemWidth(ui.fill);
                }
                var v: i64 = if (held) self.held_integer else n;
                const changed = ui.inputNumber("##v", &v, .{});
                if (ui.isItemActive()) {
                    self.held_key = key;
                    self.held_integer = v;
                } else if (held) self.held_key = 0;
                if (changed) self.setBytes(d, p, std.mem.asBytes(&v)[0..@min(p.size, 8)]);
            },
            .number => |x| {
                if (p.kind == .f32) {
                    var v: f32 = if (held) @floatCast(self.held_number) else @floatCast(x);
                    const changed = ui.drag("##v", &v, 0.01);
                    self.hold(key, v);
                    if (changed) self.setBytes(d, p, std.mem.asBytes(&v));
                } else {
                    var v: f64 = if (held) self.held_number else x;
                    const changed = ui.inputNumber("##v", &v, .{});
                    self.hold(key, v);
                    if (changed) self.setBytes(d, p, std.mem.asBytes(&v));
                }
            },
            .floats => |f| {
                var v: [4]f32 = undefined;
                for (&v, 0..) |*o, i| o.* = @floatCast(if (held) self.held_floats[i] else f.v[i]);
                const changed = switch (f.n) {
                    2 => ui.raw("ImGui_DragFloat2Ex")(ui.str("##v"), @ptrCast(&v), 0.01, 0, 0, ui.str("%.3f"), 0),
                    3 => ui.raw("ImGui_DragFloat3Ex")(ui.str("##v"), @ptrCast(&v), 0.01, 0, 0, ui.str("%.3f"), 0),
                    else => ui.raw("ImGui_DragFloat4Ex")(ui.str("##v"), @ptrCast(&v), 0.01, 0, 0, ui.str("%.3f"), 0),
                };
                if (ui.isItemActive()) {
                    self.held_key = key;
                    for (&self.held_floats, v) |*o, x| o.* = x;
                } else if (held) self.held_key = 0;
                if (changed) {
                    var bytes: [32]u8 = undefined;
                    if (f.elem == 8) {
                        var dv: [4]f64 = undefined;
                        for (&dv, v) |*o, x| o.* = x;
                        @memcpy(bytes[0 .. f.n * 8], std.mem.sliceAsBytes(dv[0..f.n]));
                        self.setBytes(d, p, bytes[0 .. f.n * 8]);
                    } else self.setBytes(d, p, std.mem.sliceAsBytes(v[0..f.n]));
                }
            },
            .text => |s| ui.textDisabled("{s}", .{s}),
            .object => |target| {
                if (target == 0) {
                    ui.textDisabled("None", .{});
                } else if (ui.selectable(ui.format("{s}###obj", .{p.label}), false)) {
                    self.picked = target;
                    self.picked_function = 0;
                    self.actions.push(.{ .select = target });
                }
                if (target != 0 and ui.isItemHovered()) ui.tooltip("Look at it", .{});
            },
        }
    }

    fn hold(self: *Explorer, key: u64, v: anytype) void {
        if (ui.isItemActive()) {
            self.held_key = key;
            self.held_number = v;
        } else if (self.held_key == key) self.held_key = 0;
    }

    fn setBytes(self: *Explorer, d: *const Details, p: *const Prop, bytes: []const u8) void {
        var a: Action = .{ .set_bytes = .{ .object = d.object, .at = p.at, .bytes = undefined, .len = @intCast(@min(bytes.len, 32)) } };
        @memcpy(a.set_bytes.bytes[0..a.set_bytes.len], bytes[0..a.set_bytes.len]);
        self.actions.push(a);
    }

    fn drawFunctions(self: *Explorer, functions: []const Func) void {
        const table = ui.table("functions", 3, .{ .borders = true, .resizable = true, .sizing = .stretch_prop }) orelse return;
        defer table.end();
        ui.tableColumnWith("Function", .{ .stretch = true, .width = 3 });
        ui.tableColumnWith("Params", .{ .stretch = true, .width = 1 });
        ui.tableColumnWith("Class", .{ .stretch = true, .width = 2 });
        for (functions) |f| {
            ui.tableNextRow();
            _ = ui.tableNextColumn();
            if (ui.selectable(ui.format("{s}{s}###{x}", .{ f.name, if (f.static) " (static)" else "", f.function }), f.function == self.picked_function)) self.picked_function = f.function;
            _ = ui.tableNextColumn();
            if (f.params == 0) ui.textDisabled("none", .{}) else ui.textDisabled("{d} bytes", .{f.params});
            _ = ui.tableNextColumn();
            ui.textDisabled("{s}", .{f.class});
        }
    }

    fn inspectorCommands(self: *Explorer, d: *const Details) void {
        var menu = ui.commands("inspector", .{});
        defer menu.end();
        const callable = for (d.functions) |f| {
            if (f.function == self.picked_function) break f.params == 0;
        } else false;
        if (menu.item(.{ .label = "Call", .enabled = callable, .default = true, .tooltip = "Calls the picked function on it. Only ones that take nothing" })) {
            self.actions.push(.{ .call = .{ .object = d.object, .function = self.picked_function } });
        }
        if (menu.item(.{ .label = "Show class", .tooltip = "Its class, in Classes" })) self.showClass(d.class);
        if (menu.item(.{ .label = "Orbit the camera round it", .enabled = self.tools != null, .tooltip = "Works for actors and scene components" })) self.actions.push(.{ .focus = d.object });
        if (menu.item(.{ .label = "Copy path", .tooltip = "Its full path, like /Game/Maps/Town.Town:PersistentLevel.Chest_3" })) ui.setClipboard(ui.format("{s}", .{d.path}));
        menu.separator();
        if (menu.item(.{ .label = "Refresh", .tooltip = "Asks Unreal again now" })) self.actions.push(.refresh);
    }

    fn showClass(self: *Explorer, class: usize) void {
        self.picked_class = class;
        self.actions.push(.{ .select_class = class });
        if (self.classes_panel) |p| p.focus();
    }

    fn drawClasses(self: *Explorer) void {
        if (self.class_split.first("list")) |part| {
            defer part.end();
            self.drawClassList();
        }
        if (self.class_split.second("class")) |part| {
            defer part.end();
            self.drawClass();
        }
    }

    fn drawClassList(self: *Explorer) void {
        ui.setNextItemWidth(ui.fill);
        _ = ui.inputTextHint("##filter", "Filter by name", &self.class_filter);
        const reading = self.classes.read() orelse return ui.textDisabled("Asking Unreal...", .{});
        defer reading.end();
        const list = reading.value.entries;
        const text = std.mem.trim(u8, std.mem.sliceTo(&self.class_filter, 0), " \t");
        if (ui.child("classes", .{ 0, 0 }, .{})) |child| {
            defer child.end();
            var shown: usize = 0;
            for (list) |e| {
                if (text.len > 0 and std.ascii.findIgnoreCase(e.name, text) == null) continue;
                if (shown == max_matches) {
                    ui.textDisabled("And {d} more. Type more of the name to narrow it down.", .{list.len - shown});
                    break;
                }
                shown += 1;
                if (ui.selectable(ui.format("{s}  {s}###{x}", .{ e.name, sortLabel(e.sort), e.class }), e.class == self.picked_class)) {
                    self.picked_class = e.class;
                    self.actions.push(.{ .select_class = e.class });
                }
            }
            if (shown == 0) ui.textDisabled("Nothing's called that.", .{});
            self.classCommands();
        }
    }

    fn drawClass(self: *Explorer) void {
        if (self.picked_class == 0) return ui.textDisabled("Pick a class to see its properties and functions.", .{});
        const reading = self.class_details.read() orelse return ui.textDisabled("Asking Unreal...", .{});
        defer reading.end();
        const d = reading.value;
        if (d.class != self.picked_class) return ui.textDisabled("Asking Unreal...", .{});
        if (d.name.len == 0) return ui.textDisabled("It's gone.", .{});
        ui.text("{s}", .{d.name});
        ui.sameLine();
        ui.textDisabled("{s}, {d} bytes", .{ sortLabel(d.sort), d.size });
        if (ui.isItemHovered()) ui.tooltip("{s}", .{d.path});
        for (d.supers) |s| {
            ui.sameLine();
            if (ui.selectable(ui.format("< {s}###{x}", .{ s.name, s.class }), false)) {
                self.picked_class = s.class;
                self.actions.push(.{ .select_class = s.class });
            }
        }
        if (d.sort == .enumeration) {
            const table = ui.table("names", 2, .{ .borders = true, .resizable = true }) orelse return;
            defer table.end();
            ui.tableColumnWith("Name", .{ .stretch = true, .width = 3 });
            ui.tableColumnWith("Value", .{ .stretch = true, .width = 1 });
            ui.tableHeaders();
            for (d.fields) |f| {
                ui.tableNextRow();
                _ = ui.tableNextColumn();
                ui.text("{s}", .{f.name});
                _ = ui.tableNextColumn();
                ui.textDisabled("{d}", .{f.offset});
            }
            return;
        }
        if (ui.collapsingHeader(ui.format("Properties ({d})###props", .{d.fields.len}), true)) {
            if (ui.table("fields", 4, .{ .borders = true, .resizable = true })) |table| {
                defer table.end();
                ui.tableColumnWith("Name", .{ .stretch = true, .width = 3 });
                ui.tableColumnWith("Type", .{ .stretch = true, .width = 3 });
                ui.tableColumnWith("Offset", .{ .stretch = true, .width = 1 });
                ui.tableColumnWith("Size", .{ .stretch = true, .width = 1 });
                ui.tableHeaders();
                for (d.fields) |f| {
                    ui.tableNextRow();
                    _ = ui.tableNextColumn();
                    ui.text("{s}", .{f.name});
                    _ = ui.tableNextColumn();
                    ui.textDisabled("{s}", .{f.type});
                    _ = ui.tableNextColumn();
                    ui.textDisabled("0x{x}", .{f.offset});
                    _ = ui.tableNextColumn();
                    ui.textDisabled("{d}", .{f.size});
                }
            }
        }
        if (d.functions.len > 0 and ui.collapsingHeader(ui.format("Functions ({d})###functions", .{d.functions.len}), true)) {
            if (ui.table("functions", 2, .{ .borders = true, .resizable = true })) |table| {
                defer table.end();
                ui.tableColumnWith("Name", .{ .stretch = true, .width = 3 });
                ui.tableColumnWith("Params", .{ .stretch = true, .width = 1 });
                ui.tableHeaders();
                for (d.functions) |f| {
                    ui.tableNextRow();
                    _ = ui.tableNextColumn();
                    ui.text("{s}{s}", .{ f.name, if (f.static) " (static)" else "" });
                    _ = ui.tableNextColumn();
                    if (f.params == 0) ui.textDisabled("none", .{}) else ui.textDisabled("{d} bytes", .{f.params});
                }
            }
        }
    }

    fn classCommands(self: *Explorer) void {
        var menu = ui.commands("classes", .{});
        defer menu.end();
        const any = self.picked_class != 0;
        if (menu.item(.{ .label = "Look at one", .enabled = any, .default = true, .tooltip = "Finds a live one of it, or of what comes from it, in Scene" })) {
            self.actions.push(.{ .find_instance = self.picked_class });
            if (self.scene_panel) |p| p.focus();
        }
        if (menu.item(.{ .label = "Copy name", .chord = ui.copy_chord, .enabled = any })) {
            if (self.classes.read()) |r| {
                defer r.end();
                for (r.value.entries) |e| if (e.class == self.picked_class) ui.setClipboard(ui.format("{s}", .{e.name}));
            }
        }
        menu.separator();
        if (menu.item(.{ .label = "Refresh", .tooltip = "Asks Unreal again now" })) self.actions.push(.refresh);
    }
};

/// An actor's location, rotator and scale as a world matrix, the way the free camera sees it.
fn matrixOf(t: [3][3]f64) Mat4 {
    const rot = camera.quatOf(.{ @floatCast(t[1][0]), @floatCast(t[1][1]), @floatCast(t[1][2]) });
    return .transform(vec(t[0]), rot, vec(t[2]));
}

fn vec(v: [3]f64) Vec3 {
    return .{ .x = @floatCast(v[0]), .y = @floatCast(v[1]), .z = @floatCast(v[2]) };
}

/// The part of a world matrix the gizmo's `tool` changes, as Unreal sets it.
fn partOf(m: Mat4, tool: u8) struct { TransformPart, [3]f64 } {
    return switch (tool) {
        1 => blk: {
            const t = m.getTranslation();
            break :blk .{ .location, .{ t.x, t.y, t.z } };
        },
        2 => blk: {
            const r = camera.rotatorOf(m.rotation());
            break :blk .{ .rotation, .{ r[0], r[1], r[2] } };
        },
        else => .{ .scale, .{ m.row(0).xyz().length(), m.row(1).xyz().length(), m.row(2).xyz().length() } },
    };
}

fn plain(comptime T: type, at: usize) T {
    return @as(*align(1) const T, @ptrFromInt(at)).*;
}

fn bitOf(ue: *const Unreal, class: usize, name: []const u8) ?Bit {
    const field = ue.fieldNamed(class, name) orelse return null;
    const p = ue.property(field) orelse return null;
    const info = ue.mem.read([4]u8, field + ue.layout.property_end) orelse return null;
    if (p.offset < 0 or info[3] == 0) return null;
    return .{ .offset = @as(usize, @intCast(p.offset)) + info[1], .mask = info[3] };
}

fn callOf(ue: *const Unreal, class: usize, name: []const u8, param: []const u8) ?Call {
    const function = ue.functionNamed(class, name) orelse return null;
    const size = ue.structSize(function) orelse return null;
    return .{ .function = function, .size = @intCast(@max(size, 0)), .param = ue.offsetOf(function, param) orelse return null };
}

fn withSecond(ue: *const Unreal, call: ?Call, second: []const u8) ?Call {
    var c = call orelse return null;
    c.second = ue.offsetOf(c.function, second);
    return c;
}

pub fn plainKind(kind_name: []const u8) ?Kind {
    const map = std.StaticStringMap(Kind).initComptime(.{
        .{ "Int8Property", .i8 },
        .{ "Int16Property", .i16 },
        .{ "IntProperty", .i32 },
        .{ "Int64Property", .i64 },
        .{ "UInt16Property", .u16 },
        .{ "UInt32Property", .u32 },
        .{ "UInt64Property", .u64 },
        .{ "FloatProperty", .f32 },
        .{ "DoubleProperty", .f64 },
    });
    return map.get(kind_name);
}

/// Structs that are just floats or doubles, shown as a row of them.
pub fn floatsOf(struct_name: []const u8, size: u8) ?struct { n: u8, elem: u8 } {
    const map = std.StaticStringMap(u8).initComptime(.{
        .{ "Vector", 3 },   .{ "Rotator", 3 },     .{ "Vector2D", 2 }, .{ "Vector4", 4 },
        .{ "Quat", 4 },     .{ "LinearColor", 4 }, .{ "Plane", 4 },    .{ "Vector3f", 3 },
        .{ "Vector3d", 3 }, .{ "Rotator3f", 3 },
    });
    const n = map.get(struct_name) orelse return null;
    const elem = size / n;
    if (elem != 4 and elem != 8) return null;
    return .{ .n = n, .elem = elem };
}

/// `EFoo::Bar` as `Bar`.
fn shortEnum(name: []const u8) []const u8 {
    const i = std.mem.lastIndexOf(u8, name, "::") orelse return name;
    return name[i + 2 ..];
}

fn sortLabel(sort: Sort) []const u8 {
    return switch (sort) {
        .class => "class",
        .script_struct => "struct",
        .enumeration => "enum",
        .actor => "actor",
        .component => "component",
        .level => "level",
        .other => "",
    };
}

fn indentOf(depth: u32) []const u8 {
    const spaces = "                                ";
    return spaces[0..@min(depth * 2, spaces.len)];
}

const testing = std.testing;

test "float structs by name and size" {
    try testing.expectEqual(3, floatsOf("Vector", 12).?.n);
    try testing.expectEqual(8, floatsOf("Vector", 24).?.elem);
    try testing.expectEqual(null, floatsOf("Vector", 10));
    try testing.expectEqual(null, floatsOf("Transform", 48));
}

test "enum names without their type" {
    try testing.expectEqualStrings("ECC_Pawn", shortEnum("ECollisionChannel::ECC_Pawn"));
    try testing.expectEqualStrings("Plain", shortEnum("Plain"));
}
