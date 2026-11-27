//! Photo mode's camera extras: Lens (orthographic, near clip), Look (post-process overrides) and
//! Clean shot (hiding the HUD and on-screen widgets). Lens and Look go through our camera modifier, so
//! they're for whichever camera's on screen. Each setting's found by name, and any this Unreal hasn't
//! got just isn't shown.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const ui = sdk.ui;

const Unreal = @import("ue/Unreal.zig");
const World = @import("ue/World.zig");
const Loop = @import("loop.zig").Loop;
const Camera = @import("camera.zig").Camera;
const console = @import("console.zig");

const log = sdk.log.scoped(.unreal);
const gpa = std.heap.smp_allocator;

/// A post-process setting the player can override.
const Item = struct {
    /// `FPostProcessSettings`' field, then an older name for it
    field: []const u8,
    old: []const u8 = "",
    label: [:0]const u8,
    group: []const u8,
    kind: enum { float, vec4 } = .float,
    min: f32,
    max: f32,
    /// What it starts at once overridden, near the engine's own
    start: f32,
    format: [:0]const u8 = "%.2f",
    logarithmic: bool = false,
};

const items = [_]Item{
    .{ .field = "AutoExposureBias", .label = "Exposure", .group = "Exposure", .min = -6, .max = 6, .start = 0, .format = "%.2f EV" },
    .{ .field = "WhiteTemp", .label = "Temperature", .group = "White balance", .min = 1500, .max = 15000, .start = 6500, .format = "%.0f K" },
    .{ .field = "WhiteTint", .label = "Tint", .group = "White balance", .min = -1, .max = 1, .start = 0 },
    .{ .field = "ColorSaturation", .label = "Saturation", .group = "Colour", .kind = .vec4, .min = 0, .max = 2, .start = 1 },
    .{ .field = "ColorContrast", .label = "Contrast", .group = "Colour", .kind = .vec4, .min = 0, .max = 2, .start = 1 },
    .{ .field = "ColorGamma", .label = "Gamma", .group = "Colour", .kind = .vec4, .min = 0.2, .max = 2, .start = 1 },
    .{ .field = "ColorGain", .label = "Gain", .group = "Colour", .kind = .vec4, .min = 0, .max = 2, .start = 1 },
    .{ .field = "VignetteIntensity", .label = "Vignette", .group = "Effects", .min = 0, .max = 1, .start = 0.4 },
    .{ .field = "BloomIntensity", .label = "Bloom", .group = "Effects", .min = 0, .max = 8, .start = 0.675 },
    .{ .field = "FilmGrainIntensity", .old = "GrainIntensity", .label = "Film grain", .group = "Effects", .min = 0, .max = 1, .start = 0 },
    .{ .field = "SceneFringeIntensity", .label = "Chromatic aberration", .group = "Effects", .min = 0, .max = 5, .start = 0 },
    // Off once ticked, since it's mostly there to be turned off
    .{ .field = "MotionBlurAmount", .label = "Motion blur", .group = "Effects", .min = 0, .max = 1, .start = 0 },
    .{ .field = "DepthOfFieldFocalDistance", .label = "Focus distance", .group = "Depth of field", .min = 1, .max = 100_000, .start = 1000, .format = "%.0f cm", .logarithmic = true },
    .{ .field = "DepthOfFieldFstop", .label = "Aperture", .group = "Depth of field", .min = 0.7, .max = 32, .start = 4, .format = "f/%.1f", .logarithmic = true },
    .{ .field = "DepthOfFieldSensorWidth", .label = "Sensor width", .group = "Depth of field", .min = 5, .max = 100, .start = 24.576, .format = "%.1f mm" },
};

/// What turns depth of field off, each at 0: cinematic's focus distance, then Gaussian's blur sizes
/// and the old Bokeh's scale.
const dof_off = [_][]const u8{ "DepthOfFieldFocalDistance", "DepthOfFieldNearBlurSize", "DepthOfFieldFarBlurSize", "DepthOfFieldScale" };

/// Off turns this down too, since some games' depth of field wins over ours, like Dragon Quest VII
/// Reimagined's.
const dof_quality = "r.DepthOfFieldQuality";
/// The engine's own, for when the game's can't be read.
const dof_quality_default = 2;

/// Where an item's value and its `bOverride_` bit are in `FPostProcessSettings`.
const Field = struct { at: usize, bit: Unreal.Bit };

const Offsets = struct {
    /// `PlayerCameraManager.ViewTarget.POV`, the view being made while our modifier runs
    pov: ?usize = null,
    /// In `MinimalViewInfo`
    projection: ?usize = null,
    ortho_width: ?usize = null,
    near_clip: ?usize = null,
    /// `CameraModifier.BlueprintModifyPostProcess` and its params
    post: ?usize = null,
    weight: usize = 0,
    settings: usize = 0,
    fields: [items.len]?Field = @splat(null),
    no_dof: [dof_off.len]?Field = @splat(null),
    /// `PlayerController.MyHUD` and `HUD.bShowHUD`
    my_hud: ?usize = null,
    show_hud: ?Unreal.Bit = null,
    /// `UserWidget`, and its calls
    widget: usize = 0,
    /// `Widget.Slot`, which top-level ones haven't got
    slot: ?usize = null,
    in_viewport: ?Unreal.Call = null,
    get_visibility: ?Unreal.Call = null,
    set_visibility: ?Unreal.Call = null,

    fn lens(o: *const Offsets) bool {
        return o.pov != null and (o.projection != null or o.near_clip != null);
    }

    fn look(o: *const Offsets) bool {
        if (o.post == null) return false;
        for (o.fields) |f| if (f != null) return true;
        return false;
    }

    fn widgets(o: *const Offsets) bool {
        return o.widget != 0 and o.in_viewport != null and o.get_visibility != null and o.set_visibility != null;
    }

    fn clean(o: *const Offsets) bool {
        return (o.my_hud != null and o.show_hud != null) or o.widgets();
    }
};

/// What the player's picked, from the render thread for the game thread.
const Want = struct {
    ortho: bool = false,
    /// Centimetres across
    ortho_width: f32 = 1000,
    /// Centimetres, or 0 for the game's
    near_clip: f32 = 0,
    look: [items.len]?f32 = @splat(null),
    /// Over the game's depth of field and any ticked above
    no_dof: bool = false,
    clean: bool = false,
};

/// A widget Clean shot hid, and how it was.
const Hidden = struct { widget: usize, slot: u32, visibility: u8 };

/// `ESlateVisibility`
const visible = 0;
const hit_test_invisible = 3;
const self_hit_test_invisible = 4;
const hidden_visibility = 2;

/// Objects looked through a tick for widgets, so no one frame takes the lot.
const scan_per_tick = 8 * 1024;

pub const Photo = struct {
    world: *const World = undefined,
    loop: *Loop = undefined,
    camera: *const Camera = undefined,
    off: Offsets = .{},
    lock: sdk.sync.RwLock = .{},
    /// Under `lock`
    want: Want = .{},
    contributions: std.ArrayList(W.Contribution) = .empty,
    // Game thread only from here down
    hiding: bool = false,
    hidden: std.ArrayList(Hidden) = .empty,
    hud: usize = 0,
    hud_was: bool = true,
    scan_at: usize = 0,
    /// On-screen widgets seen this pass, and whether the first pass has been logged
    seen: u32 = 0,
    said: bool = false,
    /// The game's depth of field quality while Off has it at 0
    dof_was: ?i32 = null,

    /// Finds what it can, and watches our modifier for what it found. Before the loop starts.
    pub fn start(self: *Photo, world: *const World, loop: *Loop, camera: *const Camera) void {
        self.world = world;
        self.loop = loop;
        self.camera = camera;
        self.off = find(world.ue, camera);
        if (self.off.lens()) loop.watch(camera.off.modify, self, onModify);
        if (self.off.look()) loop.watch(self.off.post.?, self, onPostProcess);
        const ui_area = (sdk.wraith.root() orelse return).ui();
        if (self.off.lens()) self.contribute(ui_area, .{ .slot = "photo.inspector", .id = "lens", .kind = "camera", .title = "Lens", .presentation = .foldout, .open = true, .order = 300 }, drawLens);
        // Without one, Wraith's own says there's none
        if (self.off.look()) self.contribute(ui_area, .{ .slot = "photo.inspector", .id = "look", .kind = "camera", .title = "Look", .presentation = .foldout, .open = true, .order = 400 }, drawLook);
        if (self.off.clean()) self.contribute(ui_area, .{ .slot = "photo.toolbar", .id = "clean_shot", .order = 450 }, drawClean);
        var found: usize = 0;
        for (self.off.fields) |f| found += @intFromBool(f != null);
        if (!self.off.look()) log.warn("Photo mode has no look. {s}", .{noLook(&self.off)});
        log.debug("Photo mode has {s}lens, {d} of {d} look settings, and {s}clean shot", .{ if (self.off.lens()) "" else "no ", if (self.off.look()) found else 0, items.len, if (self.off.clean()) "" else "no " });
    }

    fn contribute(self: *Photo, ui_area: W.Ui, placement: W.Slot.Placement, comptime draw: fn (*Photo, W.Slot.Target) void) void {
        // An older Wraith has no slots, so there's just nothing to show
        const c = ui_area.contribute(placement, .init(self, draw)) catch |err| return log.debug("No {s} in Photo mode: {t}", .{ placement.id, err });
        self.contributions.append(gpa, c) catch c.remove();
    }

    /// Takes its parts out of Photo mode, waiting for a draw under way.
    pub fn stop(self: *Photo) void {
        for (self.contributions.items) |c| c.remove();
        self.contributions.deinit(gpa);
        self.contributions = .empty;
    }

    pub fn deinit(self: *Photo) void {
        self.hidden.deinit(gpa);
    }

    fn wanted(self: *Photo) Want {
        self.lock.lockShared();
        defer self.lock.unlockShared();
        return self.want;
    }

    // Finding it all, each on its own so whatever's missing only takes itself

    fn find(ue: *const Unreal, camera: *const Camera) Offsets {
        var o: Offsets = .{};
        const engine = [_][]const u8{ "PlayerCameraManager", "TViewTarget", "MinimalViewInfo", "PostProcessSettings", "PlayerController", "HUD" };
        var found: [engine.len]usize = undefined;
        ue.findIn("/Script/Engine", &engine, &found);
        const manager, const view_target, const view_info, const settings, const controller, const hud = found;

        if (manager != 0 and view_target != 0 and view_info != 0) if (ue.offsetOf(manager, "ViewTarget")) |vt| if (ue.offsetOf(view_target, "POV")) |pov| {
            o.pov = vt + pov;
            o.projection = ue.offsetOf(view_info, "ProjectionMode");
            o.ortho_width = ue.offsetOf(view_info, "OrthoWidth");
            if (o.ortho_width == null) o.projection = null;
            // UE 5.1 on, where it's per view
            o.near_clip = ue.offsetOf(view_info, "PerspectiveNearClipPlane");
        };

        if (settings != 0) if (ue.functionNamed(camera.off.modifier_class, "BlueprintModifyPostProcess")) |post| {
            if (ue.offsetOf(post, "PostProcessBlendWeight")) |weight| if (ue.offsetOf(post, "PostProcessSettings")) |at| {
                o.post = post;
                o.weight = weight;
                o.settings = at;
                for (items, &o.fields) |item, *field| field.* = fieldOf(ue, settings, item.field) orelse if (item.old.len > 0) fieldOf(ue, settings, item.old) else null;
                for (dof_off, &o.no_dof) |name, *field| field.* = fieldOf(ue, settings, name);
            };
        };

        if (controller != 0 and hud != 0) {
            o.my_hud = ue.offsetOf(controller, "MyHUD");
            o.show_hud = ue.bitOf(hud, "bShowHUD");
        }

        var umg: [2]usize = undefined;
        ue.findIn("/Script/UMG", &.{ "UserWidget", "Widget" }, &umg);
        if (umg[0] != 0) {
            var missing: []const u8 = "";
            o.widget = umg[0];
            if (umg[1] != 0) o.slot = ue.offsetOf(umg[1], "Slot");
            o.in_viewport = ue.callOf(umg[0], "IsInViewport", &.{"ReturnValue"}, &missing) catch null;
            o.get_visibility = ue.callOf(umg[0], "GetVisibility", &.{"ReturnValue"}, &missing) catch null;
            o.set_visibility = ue.callOf(umg[0], "SetVisibility", &.{"InVisibility"}, &missing) catch null;
        }
        return o;
    }

    fn fieldOf(ue: *const Unreal, settings: usize, name: []const u8) ?Field {
        const at = ue.offsetOf(settings, name) orelse return null;
        var buf: [96]u8 = undefined;
        const flag = std.fmt.bufPrint(&buf, "bOverride_{s}", .{name}) catch return null;
        return .{ .at = at, .bit = ue.bitOf(settings, flag) orelse return null };
    }

    // On the game thread, from the hook

    /// Our modifier's making the view, so the projection and near clip go on it.
    fn onModify(context: *anyopaque, modifier: usize, _: ?*anyopaque) void {
        const self: *Photo = @ptrCast(@alignCast(context));
        const c = self.camera;
        if (modifier == 0 or modifier != c.modifier or c.manager == 0) return;
        const want = self.wanted();
        const pov = c.manager + self.off.pov.?;
        if (want.ortho) if (self.off.projection) |p| {
            writeRaw(u8, pov + p, 1);
            writeRaw(f32, pov + self.off.ortho_width.?, want.ortho_width);
        };
        if (want.near_clip > 0) if (self.off.near_clip) |n| writeRaw(f32, pov + n, want.near_clip);
    }

    /// Our modifier's post-process, which the camera manager blends in at its weight.
    fn onPostProcess(context: *anyopaque, modifier: usize, params: ?*anyopaque) void {
        const self: *Photo = @ptrCast(@alignCast(context));
        if (modifier == 0 or modifier != self.camera.modifier) return;
        const want = self.wanted();
        applyLook(@intFromPtr(params orelse return), &self.off, &want.look, want.no_dof, self.world.ue.layout.doubles);
    }

    /// Game thread, once a tick: depth of field's quality, and hides or puts back the HUD and widgets.
    pub fn tick(self: *Photo) void {
        const all = self.wanted();
        self.dofQuality(all.no_dof);
        if (!self.off.clean()) return;
        const want = all.clean;
        if (want and !self.hiding) {
            self.hiding = true;
            self.scan_at = 0;
            self.seen = 0;
            self.said = false;
            self.hideHud();
        }
        if (!want and self.hiding) return self.restore();
        // New widgets come along while it's on, so it keeps looking
        if (self.hiding) self.hideSome();
    }

    /// Everything back as the game had it. Game thread, as the plugin goes.
    pub fn putBack(self: *Photo) void {
        if (self.hiding) self.restore();
        self.dofQuality(false);
    }

    fn dofQuality(self: *Photo, off: bool) void {
        if (off == (self.dof_was != null)) return;
        if (off) {
            const was = console.intVariable(self.world, self.loop, dof_quality) orelse dof_quality_default;
            // Tried again next tick if there's no world yet
            if (!console.runCommand(self.world, self.loop, dof_quality ++ " 0")) return;
            self.dof_was = was;
            return;
        }
        var buf: [64]u8 = undefined;
        const back = std.fmt.bufPrint(&buf, dof_quality ++ " {d}", .{self.dof_was.?}) catch return;
        if (console.runCommand(self.world, self.loop, back)) self.dof_was = null;
    }

    fn hideHud(self: *Photo) void {
        const at = self.off.my_hud orelse return;
        const bit = self.off.show_hud orelse return;
        const controller = self.world.playerController() orelse return;
        const hud = readRaw(usize, controller + at);
        if (hud == 0) return;
        self.hud = hud;
        self.hud_was = self.world.setBit(hud, bit, false);
    }

    fn hideSome(self: *Photo) void {
        if (!self.off.widgets()) return;
        const ue = self.world.ue;
        const count = ue.objects.countPlain();
        const end = @min(self.scan_at + scan_per_tick, count);
        for (self.scan_at..end) |i| {
            const obj = ue.objects.getPlain(i);
            if (!ue.isLive(obj, self.off.widget)) continue;
            // Top-level ones too, since some games put theirs on screen without IsInViewport knowing, like
            // Dragon Quest VII Reimagined
            const top = if (self.off.slot) |at| readRaw(usize, obj + at) == 0 else false;
            if (!top and !self.returns(bool, obj, self.off.in_viewport.?)) continue;
            self.seen +%= 1;
            const was = self.returns(u8, obj, self.off.get_visibility.?);
            if (was != visible and was != hit_test_invisible and was != self_hit_test_invisible) continue;
            // Games show some again themselves, like CommonUI's as they're activated, so they're hidden again
            const known = for (self.hidden.items) |h| {
                if (h.widget == obj) break true;
            } else false;
            if (known) {
                self.setVisibility(obj, hidden_visibility);
                continue;
            }
            self.hidden.append(gpa, .{ .widget = obj, .slot = @intCast(i), .visibility = was }) catch continue;
            self.setVisibility(obj, hidden_visibility);
        }
        if (end < count) {
            self.scan_at = end;
            return;
        }
        if (!self.said) log.debug("Clean shot found {d} widgets on screen or at the top, and has {d} hidden", .{ self.seen, self.hidden.items.len });
        self.said = true;
        self.scan_at = 0;
        self.seen = 0;
    }

    /// The HUD and widgets back as they were. Game thread, and as the plugin goes.
    pub fn restore(self: *Photo) void {
        self.hiding = false;
        const ue = self.world.ue;
        for (self.hidden.items) |h| {
            if (ue.objects.isAt(h.widget, h.slot) and ue.isLive(h.widget, self.off.widget)) self.setVisibility(h.widget, h.visibility);
        }
        self.hidden.clearRetainingCapacity();
        if (self.hud != 0) if (self.off.show_hud) |bit| {
            if (self.world.playerController()) |controller| if (readRaw(usize, controller + self.off.my_hud.?) == self.hud) {
                _ = self.world.setBit(self.hud, bit, self.hud_was);
            };
        };
        self.hud = 0;
    }

    fn returns(self: *Photo, comptime T: type, obj: usize, call: Unreal.Call) T {
        var params: [32]u8 align(16) = @splat(0);
        if (call.size > params.len) return std.mem.zeroes(T);
        self.loop.call(obj, call.function, params[0..call.size]);
        return readRaw(T, @intFromPtr(&params) + call.params[0]);
    }

    fn setVisibility(self: *Photo, obj: usize, visibility: u8) void {
        const call = self.off.set_visibility.?;
        var params: [32]u8 align(16) = @splat(0);
        if (call.size > params.len) return;
        params[call.params[0]] = visibility;
        self.loop.call(obj, call.function, params[0..call.size]);
    }

    // Photo mode's parts, on the render thread

    fn drawLens(self: *Photo, _: W.Slot.Target) void {
        self.lock.lock();
        defer self.lock.unlock();
        const w = &self.want;
        if (self.off.projection != null) {
            _ = ui.checkbox("Orthographic", &w.ortho);
            ui.tooltip("No perspective, like a plan or an isometric shot. Lighting and shadows can look wrong in some games.", .{});
            if (w.ortho) {
                ui.setNextItemWidth(200);
                _ = ui.sliderWith("Width", &w.ortho_width, 10, 100_000, .{ .format = "%.0f cm", .logarithmic = true });
                ui.tooltip("How much of the world fits across. Ctrl-click to type.", .{});
            }
        }
        if (self.off.near_clip != null) {
            ui.setNextItemWidth(200);
            _ = ui.sliderWith("Near clip", &w.near_clip, 0, 100, .{ .format = if (w.near_clip > 0) "%.1f cm" else "Game's" });
            ui.tooltip("How close things can be before they're cut away. Lower for close-ups. 0 is the game's.", .{});
        }
        ui.textDisabled("For whichever camera's on screen.", .{});
    }

    fn drawLook(self: *Photo, _: W.Slot.Target) void {
        self.lock.lock();
        defer self.lock.unlock();
        var group: []const u8 = "";
        var any = self.want.no_dof;
        const can_drop_dof = self.world.console_command != null or for (self.off.no_dof) |f| {
            if (f != null) break true;
        } else false;
        for (items, self.off.fields, &self.want.look, 0..) |item, field, *value, i| {
            if (field == null) continue;
            const dof = std.mem.eql(u8, item.group, "Depth of field");
            if (!std.mem.eql(u8, item.group, group)) {
                group = item.group;
                var buf: [64:0]u8 = undefined;
                ui.separatorText(std.fmt.bufPrintSentinel(&buf, "{s}", .{group}, 0) catch "");
                if (dof and can_drop_dof) {
                    _ = ui.checkbox("Off", &self.want.no_dof);
                    ui.tooltip("No blur from focus, so things stay sharp however close the camera gets.", .{});
                }
            }
            const scope = ui.id(@as(i32, @intCast(i)));
            defer scope.end();
            const dropped = ui.disabled(dof and self.want.no_dof);
            defer dropped.end();
            var on = value.* != null;
            if (ui.checkbox("##on", &on)) value.* = if (on) item.start else null;
            ui.tooltip("{s} the game's", .{if (on) "Back to" else "Change"});
            ui.sameLine();
            var v = value.* orelse item.start;
            ui.setNextItemWidth(180);
            const off = ui.disabled(!on);
            if (ui.sliderWith(item.label, &v, item.min, item.max, .{ .format = item.format, .logarithmic = item.logarithmic })) value.* = v;
            off.end();
            any = any or on;
        }
        {
            const nothing = ui.disabled(!any);
            defer nothing.end();
            if (ui.button("Back to the game's look")) {
                self.want.look = @splat(null);
                self.want.no_dof = false;
            }
        }
        ui.textDisabled("Ticked ones go over the game's. Ctrl-click a slider to type.", .{});
    }

    fn drawClean(self: *Photo, _: W.Slot.Target) void {
        self.lock.lock();
        defer self.lock.unlock();
        const on = self.want.clean;
        const lit: ui.StyleColors = if (on) ui.withStyleColor(.button, .button_active) else ui.withColor(.button, @as(u32, 0));
        defer lit.end();
        // Lucide's eye-off and eye, from Wraith's icon font
        if (ui.iconButton(if (on) "\u{e0bb}##clean_shot" else "\u{e0ba}##clean_shot", "")) self.want.clean = !on;
        ui.tooltip("{s} the game's HUD and on-screen widgets, for a clean shot", .{if (on) "Show" else "Hide"});
    }
};

/// The ticked settings into `BlueprintModifyPostProcess`' params at `p`, each with its override, at
/// full weight. Nothing's touched when none are.
fn applyLook(p: usize, off: *const Offsets, look: []const ?f32, no_dof: bool, doubles: bool) void {
    const settings = p + off.settings;
    var any = false;
    for (items, off.fields, look) |item, field, value| {
        const f = field orelse continue;
        const v = value orelse continue;
        switch (item.kind) {
            .float => writeRaw(f32, settings + f.at, v),
            // All of it, its w, which the colour channels go by
            .vec4 => if (doubles) writeRaw([4]f64, settings + f.at, .{ 1, 1, 1, v }) else writeRaw([4]f32, settings + f.at, .{ 1, 1, 1, v }),
        }
        override(settings, f);
        any = true;
    }
    // After, so it's over a ticked focus distance
    if (no_dof) for (off.no_dof) |field| {
        const f = field orelse continue;
        writeRaw(f32, settings + f.at, 0);
        override(settings, f);
        any = true;
    };
    if (any) writeRaw(f32, p + off.weight, 1);
}

fn override(settings: usize, f: Field) void {
    writeRaw(u8, settings + f.bit.offset, readRaw(u8, settings + f.bit.offset) | f.bit.mask);
}

/// Why there's no look, as a sentence.
fn noLook(off: *const Offsets) []const u8 {
    return if (off.post == null) "This Unreal's camera modifiers have no post-process to change." else "None of its post-process settings could be found.";
}

fn readRaw(comptime T: type, at: usize) T {
    return @as(*align(1) const T, @ptrFromInt(at)).*;
}

fn writeRaw(comptime T: type, at: usize, value: T) void {
    @as(*align(1) T, @ptrFromInt(at)).* = value;
}

const testing = std.testing;

test "ticked look settings go in with their overrides, at full weight" {
    // Params: the weight, then the settings: their override bits, then exposure, then saturation
    var params: [64]u8 align(16) = @splat(0);
    var off: Offsets = .{ .post = 1, .weight = 0, .settings = 8 };
    off.fields[0] = .{ .at = 8, .bit = .{ .offset = 0, .mask = 0x4 } };
    off.fields[3] = .{ .at = 16, .bit = .{ .offset = 1, .mask = 0x1 } };
    var look: [items.len]?f32 = @splat(null);
    const p = @intFromPtr(&params);

    // Nothing ticked leaves the game's alone
    applyLook(p, &off, &look, false, false);
    try testing.expectEqual(0, readRaw(f32, p));

    look[0] = 1.5;
    look[3] = 0.25;
    // One this Unreal hasn't got is skipped
    look[1] = 7000;
    params[8] = 0x2;
    applyLook(p, &off, &look, false, false);
    try testing.expectEqual(1, readRaw(f32, p));
    try testing.expectEqual(0x2 | 0x4, params[8]);
    try testing.expectEqual(0x1, params[9]);
    try testing.expectEqual(1.5, readRaw(f32, p + 16));
    try testing.expectEqual([4]f32{ 1, 1, 1, 0.25 }, readRaw([4]f32, p + 24));

    // UE5's vectors are doubles
    applyLook(p, &off, &look, false, true);
    try testing.expectEqual([4]f64{ 1, 1, 1, 0.25 }, readRaw([4]f64, p + 24));

    // No depth of field puts its focus distance at 0, over the game's
    off.no_dof[0] = .{ .at = 48, .bit = .{ .offset = 2, .mask = 0x8 } };
    @as(*align(1) f32, @ptrFromInt(p + 56)).* = 500;
    applyLook(p, &off, &look, true, true);
    try testing.expectEqual(0, readRaw(f32, p + 56));
    try testing.expectEqual(0x8, params[10]);
}
