//! Pose characters. Game plugins hand over their skeletons each frame through the `Posing` service in
//! schemas/posing.sal, and this does the window, picking, freezing, keys and settings.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");
const poses = @import("pose.zig");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const W = sdk.api.wraith;
const ui = sdk.ui;
const Mat4 = sdk.math.Mat4;
const Vec3 = sdk.math.Vec3;

/// What the game's threads and the render thread share.
const Shared = struct {
    lock: sdk.atomic.Value(u32) = .init(0),
    /// Whether to bother the game for skeletons
    wanted: sdk.atomic.Value(bool) = .init(false),
    store: poses.Store = undefined,

    fn acquire(s: *Shared) void {
        while (s.lock.cmpxchgWeak(0, 1, .acquire, .monotonic) != null) std.atomic.spinLoopHint();
    }

    fn release(s: *Shared) void {
        s.lock.store(0, .release);
    }

    /// The service, called by game plugins.
    pub fn active(s: *Shared) bool {
        return s.wanted.load(.monotonic);
    }

    pub fn camera(s: *Shared, view: Mat4, projection: Mat4) void {
        s.acquire();
        defer s.release();
        s.store.setCamera(view, projection);
    }

    pub fn pose(s: *Shared, skeleton: schema.PosingSkeleton, matrices: *Mat4) void {
        const bones = skeleton.bones;
        const many: [*]Mat4 = @ptrCast(matrices);
        s.acquire();
        defer s.release();
        s.store.pose(skeleton.id, skeleton.name, bones, many[0..bones.len], skeleton.to_world);
    }
};

const Show = enum { posed, everyone, nobody };
const show_options = [_][]const u8{ "The one being posed", "Everyone", "No one" };

const Press = enum { window, freeze, focus };

const tools = [_][:0]const u8{ "Rotate", "Move", "Scale" };

const Key = struct {
    keybind: ?W.Keybind = null,
    which: Press,
    plugin: *Plugin = undefined,

    fn fired(self: *Key, phase: W.KeyPhase) void {
        if (phase == .pressed) self.plugin.pressed(self.which);
    }
};

const bone_colour = ui.rgba(90, 220, 120, 200);
const dim_colour = ui.rgba(160, 160, 160, 120);
const joint_colour = ui.rgba(90, 220, 120, 255);
const picked_colour = ui.rgba(255, 190, 60, 255);
const hover_colour = ui.rgba(255, 255, 255, 255);
const pick_radius = 10;

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    shared: Shared = .{},
    menu: W.MenuItem = undefined,
    show: W.Setting = undefined,
    thickness: W.Setting = undefined,
    keys: std.EnumArray(Press, Key) = .init(.{
        .window = .{ .which = .window },
        .freeze = .{ .which = .freeze },
        .focus = .{ .which = .focus },
    }),
    /// Camera Tools, to look at what's being posed
    camera: ?schema.CameraTools = null,

    // Render thread only from here down

    /// The actor and bone being posed, by id and name so they survive the game reloading them
    actor: ?u64 = null,
    bone: poses.Name = .{},
    has_bone: bool = false,
    /// Where to point the camera, once the lock's let go
    focus_at: ?Vec3 = null,
    /// Showing the cursor and keeping the keyboard and mouse from the game, like Wraith's own windows
    grabbed: bool = false,
    /// Which of `tools` the gizmo is, and whether it goes along the world's axes or the bone's
    tool: usize = 0,
    world_axes: bool = false,
    /// While the gizmo's dragged, the bone where it's dragged to, in the world. It's ours, since the
    /// bones only catch up when the game poses them next
    dragging: bool = false,
    gizmo_matrix: Mat4 = .identity,
    /// Where the bone would be without its own edit, as the drag started
    drag_base: Mat4 = .identity,
    /// Labels for the actor list, which ImGui wants null terminated
    labels: [poses.max_actors][56:0]u8 = undefined,

    pub const services = .{posing};

    pub fn posing(self: *Plugin) schema.Posing {
        return .init(&self.shared, sdk.salamander.rt.implement(schema.Posing, Shared));
    }

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        self.shared.store = try .init(std.heap.page_allocator);
        const settings = ctx.wraith.settings();
        self.show = try settings.add(.{ .id = "show", .name = "Draw skeletons of", .section = "Drawing", .help = "While the Posing window's open.", .kind = .choice, .options = &show_options }, null);
        self.thickness = try settings.add(.{ .id = "thickness", .name = "Line thickness", .section = "Drawing", .kind = .number, .min = 0.5, .max = 5, .step = 0.5, .has_default = true, .default_value = .{ .number = 1.5 } }, null);
        self.menu = ctx.wraith.ui().addMenuItem("Posing");
        self.camera = sdk.salamander.service(schema.CameraTools, "camera");
        const input = ctx.wraith.input();
        for (std.enums.values(Press)) |p| {
            const slot = self.keys.getPtr(p);
            slot.plugin = self;
            const name, const key: W.Key = switch (p) {
                .window => .{ "Open or close Posing", .f7 },
                .freeze => .{ "Freeze or unfreeze the actor being posed", .f8 },
                .focus => .{ "Orbit the camera round the picked bone", .keypad_decimal },
            };
            // Focus only does anything while the window's open, so the game keeps the key otherwise
            slot.keybind = try input.bind(.{ .id = @tagName(p), .name = name, .chord = .{ .key = key, .mods = .{} }, .passthrough = p == .focus, .while_typing = false, .scope = .global, .held = false }, W.KeybindFired.init(slot, Key.fired));
        }
        _ = try ctx.onFrame(self, tick);
    }

    pub fn stop(self: *Plugin) void {
        self.grab(false);
        // Game plugins may still call in, so the store stays. They just stop being asked
        self.shared.wanted.store(false, .monotonic);
        self.shared.acquire();
        defer self.shared.release();
        self.shared.store.edit_count = 0;
        for (self.shared.store.actors) |*a| a.frozen = false;
    }

    fn pressed(self: *Plugin, which: Press) void {
        switch (which) {
            .window => self.menu.setOpen(!self.menu.isOpen()),
            .freeze => {
                const id = self.actor orelse return;
                self.shared.acquire();
                defer self.shared.release();
                const a = self.shared.store.byId(id) orelse return;
                self.setFrozen(a, !a.frozen);
            },
            .focus => if (self.menu.isOpen()) {
                self.shared.acquire();
                defer self.shared.release();
                const a = self.current(&self.shared.store) orelse return;
                const b = self.currentBone(a) orelse return;
                self.focus_at = a.position(b);
            },
        }
    }

    fn grab(self: *Plugin, on: bool) void {
        if (self.grabbed == on) return;
        self.grabbed = on;
        const ui_api = self.ctx.wraith.ui();
        ui_api.showCursor(on);
        ui_api.takeInput(.keyboard, on);
        ui_api.takeInput(.mouse, on);
    }

    fn setFrozen(_: *Plugin, a: *poses.Actor, on: bool) void {
        a.frozen = on;
        a.base_count = 0;
    }

    fn tick(self: *Plugin) void {
        self.grab(self.menu.isOpen());
        self.draw();
        const point = self.focus_at orelse return;
        self.focus_at = null;
        if (self.camera) |c| c.focus(point);
    }

    fn draw(self: *Plugin) void {
        const open = self.menu.isOpen();
        self.shared.acquire();
        defer self.shared.release();
        const store = &self.shared.store;
        store.frame +%= 1;
        self.shared.wanted.store(open or store.edit_count > 0 or store.anyFrozen(), .monotonic);
        if (!open or !sdk.overlay.available()) return;
        self.drawSkeletons(store);
        self.drawWindow(store);
    }

    /// The posed actor, if it's still around.
    fn current(self: *Plugin, store: *poses.Store) ?*poses.Actor {
        const a = store.byId(self.actor orelse return null) orelse return null;
        return if (store.isLive(a)) a else null;
    }

    fn currentBone(self: *Plugin, a: *const poses.Actor) ?u32 {
        if (!self.has_bone) return null;
        return a.find(self.bone.get());
    }

    fn select(self: *Plugin, a: *const poses.Actor, bone: ?u32) void {
        self.actor = a.id;
        if (bone) |b| {
            self.bone = a.names[b];
            self.has_bone = true;
        } else self.has_bone = false;
    }

    fn drawSkeletons(self: *Plugin, store: *poses.Store) void {
        const show = choice(Show, self.show, &show_options);
        const vp = store.view_proj orelse return;
        const dl = ui.getBackgroundDrawList();
        const thickness = number(self.thickness, 1.5);
        const posed = self.current(store);
        const mouse = ui.getMousePos();
        const free_mouse = !ui.getIO().WantCaptureMouse;
        var hover: ?struct { actor: *poses.Actor, bone: u32, at: ui.Vec2 } = null;
        var hover_dist: f32 = pick_radius * pick_radius;

        for (store.actors) |*a| {
            if (!store.isLive(a)) continue;
            const is_posed = posed == a;
            if (show == .nobody or (show == .posed and !is_posed)) continue;
            for (0..a.count) |i| {
                const at = project(vp, a.position(i)) orelse continue;
                const p = a.parents[i];
                if (p >= 0 and p < i) {
                    if (project(vp, a.position(@intCast(p)))) |from| dl.addLine(from, at, if (is_posed or posed == null) bone_colour else dim_colour, thickness);
                }
                if (is_posed) dl.addCircleFilled(at, thickness + 1.5, joint_colour);
                if (free_mouse) {
                    const dx = at[0] - mouse[0];
                    const dy = at[1] - mouse[1];
                    const d = dx * dx + dy * dy;
                    if (d < hover_dist) {
                        hover_dist = d;
                        hover = .{ .actor = a, .bone = @intCast(i), .at = at };
                    }
                }
            }
        }

        if (posed) |a| if (self.currentBone(a)) |b| if (project(vp, a.position(b))) |at| dl.addCircle(at, 7, picked_colour, 2);
        // On the gizmo, a click's for it, not for picking another bone
        const on_gizmo = self.drawGizmo(store, posed, dl);
        if (hover) |h| if (!on_gizmo) {
            dl.addCircle(h.at, 6, hover_colour, 1.5);
            ui.mouseTooltip("{s}", .{h.actor.names[h.bone].get()});
            if (ui.isMouseClicked(.left)) self.select(h.actor, h.bone);
        };
    }

    /// Handles on the picked bone, which edit it like the boxes do. True while the mouse is on them.
    fn drawGizmo(self: *Plugin, store: *poses.Store, posed: ?*poses.Actor, dl: ui.DrawList) bool {
        const gizmo = ui.gizmo;
        gizmo.beginFrame();
        const a = posed orelse return self.stopDragging();
        const b = self.currentBone(a) orelse return self.stopDragging();
        const name = a.names[b].get();
        const view = ui.mainViewport();
        gizmo.setDrawList(dl);
        gizmo.setRect(view.pos, view.size);
        gizmo.setOrthographic(false);

        if (!self.dragging) {
            const own = if (store.findEdit(a.id, name)) |e| e.matrix() else Mat4.identity;
            self.gizmo_matrix = a.world[b].mul(a.to_world);
            self.drag_base = (own.inverse() orelse Mat4.identity).mul(a.world[b]);
        }
        const operation: gizmo.Operation = switch (self.tool) {
            0 => .rotate,
            1 => .translate,
            else => .scale,
        };
        _ = gizmo.manipulate(&store.view, &store.projection, operation, if (self.world_axes) .world else .local, &self.gizmo_matrix, .{});
        if (!gizmo.isUsing()) {
            self.dragging = false;
            return gizmo.isOver();
        }
        self.dragging = true;
        // Back into the bones' space, then less where it'd be anyway, leaves its own edit
        const from_world = a.to_world.inverse() orelse return true;
        const undo_base = self.drag_base.inverse() orelse return true;
        if (store.edit(a.id, name)) |e| e.setMatrix(self.gizmo_matrix.mul(from_world).mul(undo_base));
        return true;
    }

    fn stopDragging(self: *Plugin) bool {
        self.dragging = false;
        return false;
    }

    fn drawWindow(self: *Plugin, store: *poses.Store) void {
        var open = true;
        defer if (!open) self.menu.setOpen(false);
        const window = ui.window("Posing", .{ .open = &open, .size = .{ 380, 560 } }) orelse return;
        defer window.end();

        var ids: [poses.max_actors]*poses.Actor = undefined;
        var items: [poses.max_actors][:0]const u8 = undefined;
        var n: usize = 0;
        var selected: usize = 0;
        for (store.actors) |*a| {
            if (!store.isLive(a)) continue;
            items[n] = std.fmt.bufPrintSentinel(&self.labels[n], "{s}{s}", .{ a.name.get(), if (a.frozen) " (frozen)" else "" }, 0) catch continue;
            ids[n] = a;
            if (self.actor == a.id) selected = n;
            n += 1;
        }
        if (n == 0) {
            ui.textWrapped("Nothing to pose yet. Posing needs a plugin for this game that hands it skeletons.", .{});
            return;
        }
        if (ui.combo("Actor", &selected, items[0..n])) self.select(ids[selected], null);
        const a = ids[selected];
        if (self.actor != a.id) self.select(a, null);

        var frozen = a.frozen;
        if (ui.checkbox("Frozen", &frozen)) self.setFrozen(a, frozen);
        ui.sameLine();
        ui.textDisabled("{s} to switch", .{self.keyName(.freeze)});
        if (store.hasEdits(a.id)) {
            ui.sameLine();
            if (ui.smallButton("Reset actor")) store.resetActor(a.id);
        }

        if (ui.child("bones", .{ 0, ui.scaled(220) }, .{ .border = true })) |c| {
            defer c.end();
            self.boneList(store, a);
        }

        const bone = self.currentBone(a) orelse {
            ui.textDisabled("Pick a bone, here or by clicking on it", .{});
            return;
        };
        const name = a.names[bone].get();
        var title: [64:0]u8 = undefined;
        ui.separatorText(std.fmt.bufPrintSentinel(&title, "{s}", .{name}, 0) catch "Bone");
        ui.setNextItemWidth(ui.scaled(110));
        _ = ui.combo("Gizmo", &self.tool, &tools);
        ui.sameLine();
        _ = ui.checkbox("World axes", &self.world_axes);
        var edit: poses.Edit = if (store.findEdit(a.id, name)) |e| e.* else .{ .actor = a.id, .bone = .init(name) };
        var changed = false;
        changed = ui.drag("Rotation", &edit.rotation, 0.25) or changed;
        changed = ui.drag("Position", &edit.position, 0.002) or changed;
        changed = ui.drag("Scale", &edit.scale, 0.002) or changed;
        if (changed) {
            if (edit.isNothing()) store.resetBone(a.id, name) else if (store.edit(a.id, name)) |e| {
                e.* = edit;
            } else ui.textDisabled("Too many posed bones", .{});
        }
        if (self.camera != null) {
            if (ui.button("Focus camera")) self.focus_at = a.position(bone);
            ui.tooltip("Orbits the camera round this bone. {s} does it too.", .{self.keyName(.focus)});
            ui.sameLine();
        }
        if (store.findEdit(a.id, name) != null and ui.button("Reset bone")) store.resetBone(a.id, name);
        ui.textDisabled("In the bone's own axes. Double-click a box to type.", .{});
    }

    /// The bones as an indented tree, with posed ones marked.
    fn boneList(self: *Plugin, store: *poses.Store, a: *const poses.Actor) void {
        var depth: [poses.max_bones]u8 = undefined;
        const picked = self.currentBone(a);
        var buf: [96:0]u8 = undefined;
        const pad: [32]u8 = @splat(' ');
        for (0..a.count) |i| {
            const p = a.parents[i];
            depth[i] = if (p >= 0 and p < i) @min(depth[@intCast(p)] + 1, pad.len / 2) else 0;
            const name = a.names[i].get();
            const mark = if (store.findEdit(a.id, name) != null) " *" else "";
            const label = std.fmt.bufPrintSentinel(&buf, "{s}{s}{s}##{d}", .{ pad[0 .. depth[i] * 2], name, mark, i }, 0) catch continue;
            if (ui.selectable(label, picked == @as(u32, @intCast(i)))) self.select(a, @intCast(i));
        }
    }

    fn keyName(self: *Plugin, which: Press) []const u8 {
        const kb = self.keys.getPtrConst(which).keybind orelse return "no key";
        const all = kb.chords();
        if (all.len == 0) return "no key";
        const c = all[0];
        const chord: sdk.keybinds.Chord = .{
            .key = @fromBackingInt(@backingInt(c.key)),
            .mods = .{ .ctrl = c.mods.ctrl, .shift = c.mods.shift, .alt = c.mods.alt, .super = c.mods.super },
        };
        return ui.chordName(&key_name_buf, chord);
    }
};

var key_name_buf: [48]u8 = undefined;

/// World to screen through the camera, row-vector style.
fn project(vp: Mat4, p: Vec3) ?ui.Vec2 {
    const clip = vp.transformVec4(p.withW(1));
    if (clip.w < 0.01) return null;
    const view = ui.mainViewport();
    return .{
        view.pos[0] + (clip.x / clip.w * 0.5 + 0.5) * view.size[0],
        view.pos[1] + (0.5 - clip.y / clip.w * 0.5) * view.size[1],
    };
}

fn number(s: W.Setting, fallback: f32) f32 {
    const v = s.get() catch return fallback;
    return @floatCast(v.number);
}

/// Which of `options` it's on, as `E`'s values in the same order.
fn choice(comptime E: type, s: W.Setting, options: []const []const u8) E {
    const v = s.get() catch return @fromBackingInt(0);
    for (options, 0..) |o, i| if (std.mem.eql(u8, o, v.text)) return @fromBackingInt(@intCast(i));
    return @fromBackingInt(0);
}

test {
    _ = poses;
}

comptime {
    sdk.exportPlugin(Plugin);
}
