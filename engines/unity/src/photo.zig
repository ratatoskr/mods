//! Photo mode's camera extras: Lens (orthographic, near clip) on whichever camera's on screen, Look
//! (post-processing through a global volume of ours, in URP, HDRP or Post-Processing v2) and Clean
//! shot (hiding the game's UI canvases). Each setting's found by name, and any this Unity hasn't got
//! just isn't shown. The log says what's missing.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const ui = sdk.ui;

const engine_ = @import("engine.zig");
const Object = engine_.Object;
const scene_ = @import("scene.zig");
const Scene = scene_.Scene;
const Camera = @import("camera.zig").Camera;

const log = sdk.log.scoped(.unity);
const gpa = std.heap.smp_allocator;

/// A pipeline with volumes, and how its volumes, profiles and parameters are named.
const Pipeline = struct {
    name: []const u8,
    /// Its effects' namespace, like `UnityEngine.Rendering.Universal`
    ns: []const u8,
    volume: []const u8,
    profile: []const u8,
    /// Adds an effect to a profile, by its `System.Type`
    add: []const u8,
    /// Whether `add` also takes whether to override everything, which we don't
    add_takes_flag: bool,
    /// A parameter's value and whether it overrides
    value: []const u8,
    override: []const u8,
    /// The camera's component with its volume layer mask, and the mask's field
    camera_data: []const u8,
    mask: []const u8,
    /// Post-Processing v2's effects have an `enabled` parameter that's off till overridden
    enabled_param: bool,
    /// Index into an `Item`'s `in`
    which: enum { srp, ppv2 },
};

const pipelines = [_]Pipeline{
    .{ .name = "URP", .ns = "UnityEngine.Rendering.Universal", .volume = "UnityEngine.Rendering.Volume", .profile = "UnityEngine.Rendering.VolumeProfile", .add = "Add", .add_takes_flag = true, .value = "m_Value", .override = "m_OverrideState", .camera_data = "UnityEngine.Rendering.Universal.UniversalAdditionalCameraData", .mask = "m_VolumeLayerMask", .enabled_param = false, .which = .srp },
    .{ .name = "HDRP", .ns = "UnityEngine.Rendering.HighDefinition", .volume = "UnityEngine.Rendering.Volume", .profile = "UnityEngine.Rendering.VolumeProfile", .add = "Add", .add_takes_flag = true, .value = "m_Value", .override = "m_OverrideState", .camera_data = "UnityEngine.Rendering.HighDefinition.HDAdditionalCameraData", .mask = "volumeLayerMask", .enabled_param = false, .which = .srp },
    .{ .name = "Post-Processing v2", .ns = "UnityEngine.Rendering.PostProcessing", .volume = "UnityEngine.Rendering.PostProcessing.PostProcessVolume", .profile = "UnityEngine.Rendering.PostProcessing.PostProcessProfile", .add = "AddSettings", .add_takes_flag = false, .value = "value", .override = "overrideState", .camera_data = "UnityEngine.Rendering.PostProcessing.PostProcessLayer", .mask = "volumeLayer", .enabled_param = true, .which = .ppv2 },
};

/// Where an item is in one pipeline: its effect and parameter, and what its value's multiplied by.
const Ref = struct {
    component: []const u8,
    field: []const u8,
    scale: f32 = 1,
    /// Another parameter on the same effect that's set too, for a mode `field` does nothing in
    also: ?[]const u8 = null,
    also_scale: f32 = 1,
};

/// A post-processing setting the player can override, in URP's and HDRP's ranges.
const Item = struct {
    label: [:0]const u8,
    group: []const u8,
    /// URP and HDRP's, then Post-Processing v2's
    in: [2]?Ref,
    min: f32,
    max: f32,
    start: f32,
    format: [:0]const u8 = "%.2f",
    logarithmic: bool = false,

    fn ref(item: Item, p: Pipeline) ?Ref {
        return item.in[@backingInt(p.which)];
    }
};

const items = [_]Item{
    // v2 only takes exposure grading in HDR, and brightness in LDR, so it gets both
    .{ .label = "Exposure", .group = "Exposure", .in = .{ .{ .component = "ColorAdjustments", .field = "postExposure" }, .{ .component = "ColorGrading", .field = "postExposure", .also = "brightness", .also_scale = 20 } }, .min = -6, .max = 6, .start = 0, .format = "%.2f EV" },
    .{ .label = "Temperature", .group = "White balance", .in = .{ .{ .component = "WhiteBalance", .field = "temperature" }, .{ .component = "ColorGrading", .field = "temperature" } }, .min = -100, .max = 100, .start = 0, .format = "%.0f" },
    .{ .label = "Tint", .group = "White balance", .in = .{ .{ .component = "WhiteBalance", .field = "tint" }, .{ .component = "ColorGrading", .field = "tint" } }, .min = -100, .max = 100, .start = 0, .format = "%.0f" },
    .{ .label = "Saturation", .group = "Colour", .in = .{ .{ .component = "ColorAdjustments", .field = "saturation" }, .{ .component = "ColorGrading", .field = "saturation" } }, .min = -100, .max = 100, .start = 0, .format = "%.0f" },
    .{ .label = "Contrast", .group = "Colour", .in = .{ .{ .component = "ColorAdjustments", .field = "contrast" }, .{ .component = "ColorGrading", .field = "contrast" } }, .min = -100, .max = 100, .start = 0, .format = "%.0f" },
    .{ .label = "Hue", .group = "Colour", .in = .{ .{ .component = "ColorAdjustments", .field = "hueShift" }, .{ .component = "ColorGrading", .field = "hueShift" } }, .min = -180, .max = 180, .start = 0, .format = "%.0f\u{00B0}" },
    .{ .label = "Vignette", .group = "Effects", .in = .{ .{ .component = "Vignette", .field = "intensity" }, .{ .component = "Vignette", .field = "intensity" } }, .min = 0, .max = 1, .start = 0.3 },
    .{ .label = "Bloom", .group = "Effects", .in = .{ .{ .component = "Bloom", .field = "intensity" }, .{ .component = "Bloom", .field = "intensity" } }, .min = 0, .max = 10, .start = 1 },
    .{ .label = "Film grain", .group = "Effects", .in = .{ .{ .component = "FilmGrain", .field = "intensity" }, .{ .component = "Grain", .field = "intensity" } }, .min = 0, .max = 1, .start = 0.3 },
    .{ .label = "Chromatic aberration", .group = "Effects", .in = .{ .{ .component = "ChromaticAberration", .field = "intensity" }, .{ .component = "ChromaticAberration", .field = "intensity" } }, .min = 0, .max = 1, .start = 0.3 },
    // v2's goes by the shutter's angle
    .{ .label = "Motion blur", .group = "Effects", .in = .{ .{ .component = "MotionBlur", .field = "intensity" }, .{ .component = "MotionBlur", .field = "shutterAngle", .scale = 360 } }, .min = 0, .max = 1, .start = 0 },
    .{ .label = "Lens distortion", .group = "Effects", .in = .{ .{ .component = "LensDistortion", .field = "intensity" }, .{ .component = "LensDistortion", .field = "intensity", .scale = 100 } }, .min = -1, .max = 1, .start = 0 },
    .{ .label = "Focus distance", .group = "Depth of field", .in = .{ .{ .component = "DepthOfField", .field = "focusDistance" }, .{ .component = "DepthOfField", .field = "focusDistance" } }, .min = 0.1, .max = 100, .start = 10, .format = "%.1f m", .logarithmic = true },
    .{ .label = "Aperture", .group = "Depth of field", .in = .{ .{ .component = "DepthOfField", .field = "aperture" }, .{ .component = "DepthOfField", .field = "aperture" } }, .min = 1, .max = 32, .start = 5.6, .format = "f/%.1f", .logarithmic = true },
    .{ .label = "Focal length", .group = "Depth of field", .in = .{ .{ .component = "DepthOfField", .field = "focalLength" }, .{ .component = "DepthOfField", .field = "focalLength" } }, .min = 1, .max = 300, .start = 50, .format = "%.0f mm" },
};

/// URP and HDRP's depth of field is off till its mode says otherwise: URP's `mode` Bokeh, HDRP's
/// `focusMode` Manual, both 2.
const dof_on = 2;
/// Their `Off`
const dof_off = 0;

/// Depth of field as the game has it, on for what's ticked, or off.
const Dof = enum { game, on, off };

fn Get(comptime T: type) type {
    return ?*const fn (*Object) callconv(.c) T;
}

fn Set(comptime T: type) type {
    return ?*const fn (*Object, T) callconv(.c) void;
}

/// Unity's calls on cameras, canvases and objects, each found on its own. Ones the camera has as
/// properties are called through the runtime instead when the engine has no call for them.
const Calls = struct {
    get_ortho: Get(bool) = null,
    set_ortho: Set(bool) = null,
    get_size: Get(f32) = null,
    set_size: Set(f32) = null,
    get_near: Get(f32) = null,
    set_near: Set(f32) = null,
    get_enabled: Get(bool) = null,
    set_enabled: Set(bool) = null,
    /// Screen space overlay 0, screen space camera 1, world space 2
    render_mode: Get(i32) = null,
    add_component: ?*const fn (*Object, *Object) callconv(.c) ?*Object = null,
    destroy: ?*const fn (*Object, f32) callconv(.c) void = null,

    const names = .{
        .get_ortho = .{ "UnityEngine.Camera", "get_orthographic" },
        .set_ortho = .{ "UnityEngine.Camera", "set_orthographic" },
        .get_size = .{ "UnityEngine.Camera", "get_orthographicSize" },
        .set_size = .{ "UnityEngine.Camera", "set_orthographicSize" },
        .get_near = .{ "UnityEngine.Camera", "get_nearClipPlane" },
        .set_near = .{ "UnityEngine.Camera", "set_nearClipPlane" },
        .get_enabled = .{ "UnityEngine.Behaviour", "get_enabled" },
        .set_enabled = .{ "UnityEngine.Behaviour", "set_enabled" },
        .render_mode = .{ "UnityEngine.Canvas", "get_renderMode" },
        .add_component = .{ "UnityEngine.GameObject", "Internal_AddComponentWithType", "AddComponent" },
        .destroy = .{ "UnityEngine.Object", "Destroy" },
    };

    fn find(m: W.Managed) Calls {
        var out: Calls = .{};
        inline for (@typeInfo(Calls).@"struct".field_names) |field| {
            const want = @field(names, field);
            const F = @typeInfo(@FieldType(Calls, field)).optional.child;
            @field(out, field) = inline for (1..want.len) |i| {
                if (m.icall(want[0], want[i])) |at| break @as(F, @ptrFromInt(at)) else |_| {}
            } else null;
        }
        return out;
    }

    fn canvases(c: *const Calls) bool {
        return c.get_enabled != null and c.set_enabled != null;
    }

    fn volumes(c: *const Calls) bool {
        return c.add_component != null and c.destroy != null;
    }
};

/// A camera property: through the engine's call, or the runtime's method when there's none.
fn Property(comptime T: type) type {
    return struct {
        const Self = @This();

        get: Get(T) = null,
        set: Set(T) = null,
        /// Like `orthographic`, for `get_` and `set_` through the runtime
        name: []const u8,
        /// The runtime has its methods, for when the engine's calls are missing
        invoked: bool = false,

        fn find(self: *Self, m: W.Managed) void {
            if (self.get != null and self.set != null) return;
            var buf: [64]u8 = undefined;
            const get = std.fmt.bufPrint(&buf, "get_{s}", .{self.name}) catch return;
            _ = m.findMethod("UnityEngine.Camera", get, 0) catch return;
            const set = std.fmt.bufPrint(&buf, "set_{s}", .{self.name}) catch return;
            _ = m.findMethod("UnityEngine.Camera", set, 1) catch return;
            self.invoked = true;
        }

        fn has(self: *const Self) bool {
            return (self.get != null and self.set != null) or self.invoked;
        }

        /// Cheap enough for every frame, or only on change through the runtime.
        fn cheap(self: *const Self) bool {
            return self.get != null and self.set != null;
        }

        fn read(self: *const Self, m: W.Managed, cam: *Object) ?T {
            if (self.get) |f| if (self.set != null) return f(cam);
            var buf: [64]u8 = undefined;
            const name = std.fmt.bufPrint(&buf, "get_{s}", .{self.name}) catch return null;
            const v = m.invoke("UnityEngine.Camera", name, @intFromPtr(cam), &.{}) catch return null;
            return if (T == bool) v.flag else @floatCast(v.number);
        }

        fn write(self: *const Self, m: W.Managed, cam: *Object, value: T) void {
            if (self.set) |f| if (self.get != null) return f(cam, value);
            var buf: [64]u8 = undefined;
            const name = std.fmt.bufPrint(&buf, "set_{s}", .{self.name}) catch return;
            const arg: W.Managed.Value = if (T == bool) .{ .kind = .flag, .flag = value } else .{ .kind = .number, .number = value };
            _ = m.invoke("UnityEngine.Camera", name, @intFromPtr(cam), &.{arg}) catch |err| log.debug("Couldn't {s}: {t}", .{ name, err });
        }
    };
}

/// What the player's picked, from the render thread for the main thread.
const Want = struct {
    ortho: bool = false,
    /// Half the view's height, in metres, as Unity has it
    ortho_size: f32 = 5,
    /// Metres, or 0 for the game's
    near_clip: f32 = 0,
    look: [items.len]?f32 = @splat(null),
    /// Over the game's depth of field and any ticked above
    no_dof: bool = false,
    clean: bool = false,
};

/// A camera Lens changed, what it had, and what it was last given.
const Lensed = struct {
    camera: *Object,
    native: usize,
    ortho: bool,
    size: f32,
    near: f32,
    gave: ?Want = null,
};

/// A canvas Clean shot turned off.
const Hidden = struct { hold: u32, native: usize };

/// Our volume and what's in it, each held so the runtime doesn't take them.
const Volume = struct {
    game_object: u32 = 0,
    native: usize = 0,
    profile: u32 = 0,
    /// The volume component
    component: u32 = 0,
    /// Each item's effect and parameter, made as they're first used
    components: [items.len]u32 = @splat(0),
    params: [items.len]u32 = @splat(0),
};

/// Our volume's priority, unless a game's is higher.
const start_priority = 10_000;

/// Our volume's GameObject, so it's known in Unity's own tools.
const volume_name = "Wraith photo mode look";

/// Frames between looks for new canvases while Clean shot's on.
const rescan_frames = 30;

pub const Photo = struct {
    managed: W.Managed = undefined,
    scene: *Scene = undefined,
    camera: *const Camera = undefined,
    calls: Calls = .{},
    ortho: Property(bool) = .{ .name = "orthographic" },
    size: Property(f32) = .{ .name = "orthographicSize" },
    near: Property(f32) = .{ .name = "nearClipPlane" },
    /// The pipeline whose volumes it uses, and their `System.Type`
    pipeline: ?Pipeline = null,
    volume_type: usize = 0,
    /// Items this Unity has
    found: [items.len]bool = @splat(false),
    lock: sdk.sync.RwLock = .{},
    /// Under `lock`
    want: Want = .{},
    /// Its parts of Photo mode, kept while they're in its slots
    lens_part: sdk.slots.PhotoPart = .{ .info = .{ .id = "lens", .kind = "camera", .title = "Lens", .presentation = .foldout, .open = true, .order = 300 } },
    look_info: sdk.slots.PhotoPart = .{ .info = .{ .id = "look", .kind = "camera", .title = "Look", .presentation = .foldout, .open = true, .order = 400 } },
    clean_part: sdk.slots.PhotoPart = .{ .info = .{ .id = "clean_shot", .order = 450 } },
    contributions: std.ArrayList(W.Contribution) = .empty,
    /// Look, among `contributions`, for taking out if its volume can't be made
    look_part: ?W.Contribution = null,
    /// Over `contributions` and `look_part`, since the main thread can take Look out as it stops
    parts_lock: sdk.sync.RwLock = .{},
    // Main thread only from here down
    lensed: ?Lensed = null,
    volume: ?Volume = null,
    /// What's on the volume now, so only changes are sent
    applied: [items.len]?f32 = @splat(null),
    applied_dof: Dof = .game,
    /// An item the runtime wouldn't set, so it's left alone
    broken: [items.len]bool = @splat(false),
    hidden: std.ArrayList(Hidden) = .empty,
    hiding: bool = false,
    frames: u32 = 0,
    /// Our volume's priority, kept for the next one made
    priority: f64 = start_priority,
    /// Whether v2 has the call that tells it to blend again, till it's found it hasn't
    dispatch: bool = true,

    /// Finds what it can. Blocks while the game's runtime looks, so not on the render thread.
    pub fn start(self: *Photo, managed: W.Managed, scene: *Scene, camera: *const Camera) void {
        self.managed = managed;
        self.scene = scene;
        self.camera = camera;
        self.calls = .find(managed);
        self.ortho.get = self.calls.get_ortho;
        self.ortho.set = self.calls.set_ortho;
        self.size.get = self.calls.get_size;
        self.size.set = self.calls.set_size;
        self.near.get = self.calls.get_near;
        self.near.set = self.calls.set_near;
        self.ortho.find(managed);
        self.size.find(managed);
        self.near.find(managed);
        if (self.calls.volumes()) self.findLook();
        self.say();
        if (self.hasLens()) _ = self.contribute("photo.inspector", &self.lens_part, drawLens);
        // Without one, Wraith's own says there's none
        if (self.hasLook()) self.look_part = self.contribute("photo.inspector", &self.look_info, drawLook);
        if (self.calls.canvases()) _ = self.contribute("photo.toolbar", &self.clean_part, drawClean);
    }

    /// The first pipeline whose volume class is there and has any of the items.
    fn findLook(self: *Photo) void {
        const m = self.managed;
        var buf: [160]u8 = undefined;
        for (pipelines) |p| {
            _ = m.find(p.volume) catch continue;
            var found: [items.len]bool = @splat(false);
            var any = false;
            for (items, &found) |item, *f| {
                const r = item.ref(p) orelse continue;
                const class = std.fmt.bufPrint(&buf, "{s}.{s}", .{ p.ns, r.component }) catch continue;
                f.* = if (m.fieldOffset(class, r.field)) |_| true else |_| false;
                any = any or f.*;
            }
            if (!any) continue;
            self.volume_type = m.typeObject(p.volume) catch continue;
            self.pipeline = p;
            self.found = found;
            return;
        }
    }

    /// What it found, and what's missing, so a game where something doesn't show can be looked into.
    fn say(self: *const Photo) void {
        if (!self.ortho.has() or !self.size.has()) log.debug("Photo mode has no orthographic, since this Unity's camera has no {s}", .{if (!self.ortho.has()) "orthographic" else "orthographicSize"});
        if (!self.near.has()) log.debug("Photo mode has no near clip, since this Unity's camera has no nearClipPlane", .{});
        if (self.calls.volumes()) if (self.pipeline) |p| {
            var count: usize = 0;
            for (self.found) |f| count += @intFromBool(f);
            log.debug("Photo mode's look goes through {s}, with {d} of {d} settings", .{ p.name, count, items.len });
        } else self.sayRendering() else log.warn("Photo mode has no look. This Unity can't add components to the scene.", .{});
        if (!self.calls.canvases()) log.debug("Photo mode has no clean shot, since this Unity can't turn its canvases off", .{});
    }

    /// Which of the game's assemblies look like they draw, for working out what it uses instead.
    fn sayRendering(self: *const Photo) void {
        var list: std.ArrayList(u8) = .empty;
        defer list.deinit(gpa);
        const images = self.managed.images() catch &.{};
        for (images) |image| {
            const words = [_][]const u8{ "Render", "PostProcess", "Post", "Effect", "Shader", "Graphics", "Volume" };
            const drawn = for (words) |w| {
                if (std.ascii.findIgnoreCase(image, w) != null) break true;
            } else false;
            if (!drawn) continue;
            if (list.items.len > 0) list.appendSlice(gpa, ", ") catch break;
            list.appendSlice(gpa, image) catch break;
        }
        log.warn("Photo mode has no look. It has no URP, HDRP or Post-Processing v2. Its drawing assemblies: {s}", .{if (list.items.len > 0) list.items else "none"});
    }

    fn hasOrtho(self: *const Photo) bool {
        return self.ortho.has() and self.size.has();
    }

    fn hasLens(self: *const Photo) bool {
        return self.hasOrtho() or self.near.has();
    }

    fn hasLook(self: *const Photo) bool {
        return self.pipeline != null and std.mem.indexOfScalar(bool, &self.found, true) != null;
    }

    fn contribute(self: *Photo, slot: []const u8, part: *sdk.slots.PhotoPart, comptime draw: fn (*Photo, W.Slot.Target) void) ?W.Contribution {
        // An older Wraith has no slots, so there's just nothing to show
        const c = sdk.slots.addPhotoPart(slot, part, self, draw) catch |err| {
            log.debug("No {s} in Photo mode: {t}", .{ part.info.id, err });
            return null;
        };
        self.contributions.append(gpa, c) catch {
            c.remove();
            return null;
        };
        return c;
    }

    /// Takes Look out, so Wraith's own says there's none. Waits for a draw under way, so not under `lock`.
    fn withdrawLook(self: *Photo) void {
        self.parts_lock.lock();
        defer self.parts_lock.unlock();
        const c = self.look_part orelse return;
        self.look_part = null;
        for (self.contributions.items, 0..) |other, i| if (std.meta.eql(other, c)) {
            _ = self.contributions.orderedRemove(i);
            break;
        };
        c.remove();
    }

    /// Takes its parts out of Photo mode, waiting for a draw under way.
    pub fn stop(self: *Photo) void {
        self.parts_lock.lock();
        defer self.parts_lock.unlock();
        self.look_part = null;
        for (self.contributions.items) |c| c.remove();
        self.contributions.deinit(gpa);
        self.contributions = .empty;
    }

    pub fn deinit(self: *Photo) void {
        if (self.volume != null or self.hidden.items.len > 0) log.info("Photo mode's look and hidden canvases weren't put back, since the plugin stopped without winding down", .{});
        self.hidden.deinit(gpa);
    }

    fn wanted(self: *Photo) Want {
        self.lock.lockShared();
        defer self.lock.unlockShared();
        return self.want;
    }

    // Main thread

    /// Once a frame, after the camera on screen's been picked.
    pub fn frame(self: *Photo) void {
        const want = self.wanted();
        self.lens(want);
        if (self.hasLook()) {
            // Asked till ours is made, so Unity's answered by then
            if (self.volume == null) if (self.pipeline) |p| {
                _ = self.highest(p, 0);
            };
            self.look(want);
        }
        if (self.calls.canvases()) self.clean(want.clean);
    }

    /// The highest priority of the scene's volumes other than `ours`, or null if Unity's not answered.
    fn highest(self: *Photo, p: Pipeline, ours: usize) ?f64 {
        var volumes: std.ArrayList(scene_.Found) = .empty;
        defer volumes.deinit(gpa);
        _ = self.scene.objectsOfType(gpa, p.volume, &volumes) catch return null;
        const m = self.managed;
        var top: ?f64 = null;
        for (volumes.items) |f| {
            const other = @intFromPtr(f.object);
            if (other == ours) continue;
            const got = m.getField(other, "priority") catch m.invoke(p.volume, "get_priority", other, &.{}) catch continue;
            if (got.kind == .number) top = @max(top orelse got.number, got.number);
        }
        return top;
    }

    /// Everything back as the game had it, and our volume gone. Main thread, as the plugin goes.
    pub fn windDown(self: *Photo) void {
        // Unity's calls aren't safe anywhere else, and nothing's been changed if it never ran
        if (self.camera.main_thread == 0 or std.Thread.getCurrentId() != self.camera.main_thread) return;
        self.unlens();
        self.unhide();
        self.dropVolume();
    }

    fn lens(self: *Photo, want: Want) void {
        const m = self.managed;
        const wants = (want.ortho and self.hasOrtho()) or (want.near_clip > 0 and self.near.has());
        const target = self.camera.target();
        // Another camera's on screen, or nothing's wanted, so the last one gets its own back
        if (self.lensed) |l| if (!wants or target != l.camera) self.unlens();
        if (!wants) return;
        const cam = target orelse return;
        if (self.lensed == null) self.lensed = .{
            .camera = cam,
            .native = self.scene.nativeOf(cam),
            .ortho = self.ortho.read(m, cam) orelse false,
            .size = self.size.read(m, cam) orelse 5,
            .near = self.near.read(m, cam) orelse 0.3,
        };
        const l = &self.lensed.?;
        // Through the runtime it's slow, so only when something's changed
        const same = if (l.gave) |g| g.ortho == want.ortho and g.ortho_size == want.ortho_size and g.near_clip == want.near_clip else false;
        if (self.hasOrtho() and (!same or self.ortho.cheap())) {
            self.ortho.write(m, cam, want.ortho or l.ortho);
            self.size.write(m, cam, if (want.ortho) want.ortho_size else l.size);
        }
        if (self.near.has() and (!same or self.near.cheap())) self.near.write(m, cam, if (want.near_clip > 0) want.near_clip else l.near);
        l.gave = want;
    }

    fn unlens(self: *Photo) void {
        const l = self.lensed orelse return;
        self.lensed = null;
        if (!self.scene.alive(l.camera, l.native)) return;
        const m = self.managed;
        if (self.hasOrtho()) {
            self.ortho.write(m, l.camera, l.ortho);
            self.size.write(m, l.camera, l.size);
        }
        if (self.near.has()) self.near.write(m, l.camera, l.near);
    }

    /// Sends what's changed to our volume, making it the first time anything's ticked.
    fn look(self: *Photo, want: Want) void {
        const alive = self.volumeAlive();
        if (alive and std.mem.eql(?f32, &want.look, &self.applied) and want.no_dof == (self.applied_dof == .off)) return;
        const any = want.no_dof or for (want.look) |v| {
            if (v != null) break true;
        } else false;
        if (!alive) {
            if (!any) return;
            // It's said why, so it isn't tried every frame
            self.makeVolume() catch {
                self.dropVolume();
                self.withdrawLook();
                self.pipeline = null;
                return;
            };
            self.applied = @splat(null);
        }
        // Some games' v2 only blends again when told, like Risk of Rain 2's. Others don't have it
        defer if (self.pipeline.?.which == .ppv2 and self.dispatch) {
            _ = self.managed.invoke(self.pipeline.?.volume, "DispatchVolumeSettingsChangedEvent", 0, &.{}) catch {
                self.dispatch = false;
            };
        };
        var dof: Dof = if (want.no_dof) .off else .game;
        if (dof == .game) for (items, want.look) |item, v| {
            if (v != null and std.mem.eql(u8, item.group, "Depth of field")) dof = .on;
        };
        for (items, want.look, &self.applied, 0..) |item, v, *was, i| {
            if (!self.found[i] or self.broken[i]) continue;
            if (std.meta.eql(v, was.*)) continue;
            self.setItem(i, item, v) catch |err| {
                const r = item.ref(self.pipeline.?).?;
                log.warn("Couldn't set {s}.{s} ({t}), so it's left as the game has it", .{ r.component, r.field, err });
                self.broken[i] = true;
                continue;
            };
            was.* = v;
        }
        if (dof != self.applied_dof) {
            self.setDepthOfField(dof) catch |err| log.debug("Couldn't turn depth of field {t}: {t}", .{ dof, err });
            self.applied_dof = dof;
        }
    }

    fn volumeAlive(self: *Photo) bool {
        const v = self.volume orelse return false;
        const go = self.managed.heldAt(v.game_object) catch return false;
        return self.scene.alive(@ptrFromInt(go), v.native);
    }

    fn makeVolume(self: *Photo) !void {
        var step: []const u8 = "";
        self.makeVolumeSteps(&step) catch |err| {
            log.warn("Couldn't make Photo mode's look volume, at {s}: {t}", .{ step, err });
            return err;
        };
    }

    /// `step` says how far it got, for the log.
    fn makeVolumeSteps(self: *Photo, step: *[]const u8) !void {
        // One gone with a scene change leaves its holds behind
        self.dropVolume();
        const m = self.managed;
        const p = self.pipeline.?;
        // Cameras only see volumes on the layers in their mask, so it goes on one of those
        step.* = "finding the camera's volume layer";
        const layer = try self.volumeLayer(p);
        step.* = "making its GameObject";
        const made = try m.invoke("UnityEngine.GameObject", ".ctor", 0, &.{.{ .kind = .text, .text = volume_name }});
        const go: *Object = @ptrFromInt(made.object);
        self.volume = .{ .game_object = try m.hold(made.object), .native = self.scene.nativeOf(go) };
        // Before the volume, so it's seen on its layer from the start
        step.* = "putting it on its layer";
        _ = try m.invoke("UnityEngine.GameObject", "set_layer", made.object, &.{.{ .kind = .integer, .integer = layer }});
        // Through scene changes, like the camera
        _ = m.invoke("UnityEngine.Object", "DontDestroyOnLoad", 0, &.{.{ .kind = .object, .object = made.object }}) catch {};
        // Off till it's set up, so the game's pipeline first sees it at its priority
        step.* = "switching it off";
        _ = try m.invoke("UnityEngine.GameObject", "SetActive", made.object, &.{.{ .kind = .flag, .flag = false }});
        step.* = "adding the volume";
        const volume = self.calls.add_component.?(go, @ptrFromInt(self.volume_type)) orelse return error.NoVolume;
        self.volume.?.component = try m.hold(@intFromPtr(volume));
        step.* = "making it global";
        try self.setVolume(p, @intFromPtr(volume), "isGlobal", .{ .kind = .flag, .flag = true });
        // Over the game's own
        // Above every other, since the highest's applied last and a game's can be high, like Risk of Rain 2's
        // at 99999. Set while it's off, since that pipeline breaks for good when a live one's priority changes.
        step.* = "setting its priority";
        if (self.highest(p, 0)) |top| self.priority = @max(self.priority, top + 1);
        try self.setVolume(p, @intFromPtr(volume), "priority", .{ .kind = .number, .number = self.priority });
        step.* = "getting its profile";
        const profile = try m.invoke(p.volume, "get_profile", @intFromPtr(volume), &.{});
        if (profile.object == 0) return error.NoProfile;
        self.volume.?.profile = try m.hold(profile.object);
        step.* = "switching it on";
        _ = try m.invoke("UnityEngine.GameObject", "SetActive", made.object, &.{.{ .kind = .flag, .flag = true }});
        log.debug("Photo mode's look is a {s} volume on layer {d}, at priority {d}", .{ p.name, layer, self.priority });
    }

    /// A volume's setting through its property, which newer pipelines have over a private field,
    /// else the field by its old public name, else its `m_` one.
    fn setVolume(self: *Photo, p: Pipeline, volume: usize, comptime name: []const u8, value: W.Managed.Value) !void {
        const m = self.managed;
        if (m.invoke(p.volume, "set_" ++ name, volume, &.{value})) |_| return else |_| {}
        if (m.setField(volume, name, value)) |_| return else |_| {}
        return m.setField(volume, "m_" ++ [_]u8{std.ascii.toUpper(name[0])} ++ name[1..], value);
    }

    /// The lowest layer in the on-screen camera's volume mask, or the default layer if it has no
    /// say. None at all means it sees no volumes, so there's no look to change.
    fn volumeLayer(self: *Photo, p: Pipeline) !i64 {
        const m = self.managed;
        const cam = self.camera.target() orelse return 0;
        const type_object = m.typeObject(p.camera_data) catch return 0;
        const data = (m.invoke("UnityEngine.Component", "GetComponent", @intFromPtr(cam), &.{.{ .kind = .object, .object = type_object }}) catch return 0).object;
        if (data == 0) return if (p.which == .ppv2) error.NoPostProcessLayer else 0;
        // A LayerMask struct, given as where it is in the component
        const mask_at = (m.getField(data, p.mask) catch return 0).object;
        if (mask_at == 0) return 0;
        const mask = @as(*align(1) const u32, @ptrFromInt(mask_at)).*;
        if (mask == 0) return error.CameraSeesNoVolumes;
        return @ctz(mask);
    }

    fn dropVolume(self: *Photo) void {
        const v = self.volume orelse return;
        self.volume = null;
        const m = self.managed;
        if (m.heldAt(v.game_object)) |go| {
            if (self.scene.alive(@ptrFromInt(go), v.native)) if (self.calls.destroy) |destroy| destroy(@ptrFromInt(go), 0);
        } else |_| {}
        if (v.game_object != 0) m.release(v.game_object);
        if (v.profile != 0) m.release(v.profile);
        if (v.component != 0) m.release(v.component);
        // Items on one effect share its hold
        for (v.components, 0..) |h, i| if (h != 0 and std.mem.indexOfScalar(u32, v.components[0..i], h) == null) m.release(h);
        for (v.params) |h| if (h != 0) m.release(h);
        self.applied = @splat(null);
        self.applied_dof = .game;
    }

    /// An item's parameter on our volume: its value and that it overrides, or that it doesn't.
    fn setItem(self: *Photo, i: usize, item: Item, value: ?f32) !void {
        const m = self.managed;
        const p = self.pipeline.?;
        const r = item.ref(p).?;
        const param = try self.paramOf(i, item);
        if (value) |x| try m.setField(param, p.value, .{ .kind = .number, .number = x * r.scale });
        try m.setField(param, p.override, .{ .kind = .flag, .flag = value != null });
        // Best done, since the game may not have it
        const also = r.also orelse return;
        const component = m.heldAt(self.volume.?.components[i]) catch return;
        const other = (m.getField(component, also) catch return).object;
        if (other == 0) return;
        if (value) |x| m.setField(other, p.value, .{ .kind = .number, .number = std.math.clamp(x * r.also_scale, -100, 100) }) catch {};
        m.setField(other, p.override, .{ .kind = .flag, .flag = value != null }) catch {};
    }

    fn paramOf(self: *Photo, i: usize, item: Item) !usize {
        const m = self.managed;
        if (self.volume.?.params[i] != 0) return m.heldAt(self.volume.?.params[i]);
        const component = try self.componentOf(i, item);
        const param = try m.getField(component, item.ref(self.pipeline.?).?.field);
        if (param.object == 0) return error.NoParameter;
        self.volume.?.params[i] = try m.hold(param.object);
        return param.object;
    }

    /// The item's effect on our profile, shared with the other items on it.
    fn componentOf(self: *Photo, i: usize, item: Item) !usize {
        const m = self.managed;
        const p = self.pipeline.?;
        const name = item.ref(p).?.component;
        const v = &self.volume.?;
        for (items, v.components) |other, h| {
            const o = other.ref(p) orelse continue;
            if (h != 0 and std.mem.eql(u8, o.component, name)) {
                v.components[i] = h;
                return m.heldAt(h);
            }
        }
        var buf: [160]u8 = undefined;
        const class = try std.fmt.bufPrint(&buf, "{s}.{s}", .{ p.ns, name });
        const type_object = try m.typeObject(class);
        const profile = try m.heldAt(v.profile);
        const type_arg: W.Managed.Value = .{ .kind = .object, .object = type_object };
        // Not overriding all of it, only what's ticked
        const added = if (p.add_takes_flag)
            try m.invoke(p.profile, p.add, profile, &.{ type_arg, .{ .kind = .flag, .flag = false } })
        else
            try m.invoke(p.profile, p.add, profile, &.{type_arg});
        if (added.object == 0) return error.NoComponent;
        if (p.enabled_param) {
            const enabled = (try m.getField(added.object, "enabled")).object;
            if (enabled != 0) {
                try m.setField(enabled, p.value, .{ .kind = .flag, .flag = true });
                try m.setField(enabled, p.override, .{ .kind = .flag, .flag = true });
            }
        }
        const hold = try m.hold(added.object);
        // Shared, so it's only let go of once
        for (items, &v.components) |other, *h| {
            const o = other.ref(p) orelse continue;
            if (std.mem.eql(u8, o.component, name)) h.* = hold;
        }
        return added.object;
    }

    /// Depth of field on for ticked settings, which URP and HDRP only show once their mode's on, off
    /// for Off, else the game's. v2's goes by its effect's own switch.
    fn setDepthOfField(self: *Photo, dof: Dof) !void {
        const p = self.pipeline orelse return;
        const v = &(self.volume orelse return);
        const at = for (items, self.found, 0..) |item, found, i| {
            if (found and std.mem.eql(u8, item.group, "Depth of field")) break i;
        } else return;
        // Back to the game's needs nothing made for it
        if (dof == .game and v.components[at] == 0) return;
        const m = self.managed;
        const component = if (v.components[at] != 0) try m.heldAt(v.components[at]) else try self.componentOf(at, items[at]);
        if (p.which == .ppv2) {
            const enabled = (try m.getField(component, "enabled")).object;
            if (enabled == 0) return error.NotFound;
            return m.setField(enabled, p.value, .{ .kind = .flag, .flag = dof != .off });
        }
        for ([_][]const u8{ "mode", "focusMode" }) |name| {
            const param = (m.getField(component, name) catch continue).object;
            if (param == 0) continue;
            try m.setField(param, p.value, .{ .kind = .integer, .integer = if (dof == .off) dof_off else dof_on });
            return m.setField(param, p.override, .{ .kind = .flag, .flag = dof != .game });
        }
        return error.NotFound;
    }

    fn clean(self: *Photo, want: bool) void {
        if (!want) return if (self.hiding) self.unhide();
        self.hiding = true;
        // New canvases come along while it's on, so it keeps looking now and then
        if (self.frames % rescan_frames == 0) self.hideCanvases();
        self.frames +%= 1;
    }

    fn hideCanvases(self: *Photo) void {
        const c = &self.calls;
        var found: std.ArrayList(scene_.Found) = .empty;
        defer found.deinit(gpa);
        _ = self.scene.objectsOfType(gpa, "UnityEngine.Canvas", &found) catch return;
        for (found.items) |f| {
            if (!c.get_enabled.?(f.object)) continue;
            // Signs and screens in the world stay
            if (c.render_mode) |mode| if (mode(f.object) == 2) continue;
            const hold = self.managed.hold(@intFromPtr(f.object)) catch continue;
            self.hidden.append(gpa, .{ .hold = hold, .native = f.native }) catch {
                self.managed.release(hold);
                continue;
            };
            c.set_enabled.?(f.object, false);
        }
    }

    fn unhide(self: *Photo) void {
        self.hiding = false;
        self.frames = 0;
        const m = self.managed;
        for (self.hidden.items) |h| {
            if (m.heldAt(h.hold)) |at| {
                const canvas: *Object = @ptrFromInt(at);
                if (self.scene.alive(canvas, h.native)) self.calls.set_enabled.?(canvas, true);
            } else |_| {}
            m.release(h.hold);
        }
        self.hidden.clearRetainingCapacity();
    }

    // Photo mode's parts, on the render thread

    fn drawLens(self: *Photo, _: W.Slot.Target) void {
        self.lock.lock();
        defer self.lock.unlock();
        const w = &self.want;
        if (self.hasOrtho()) {
            _ = ui.checkbox("Orthographic", &w.ortho);
            ui.tooltip("No perspective, like a plan or an isometric shot.", .{});
            if (w.ortho) {
                ui.setNextItemWidth(200);
                _ = ui.sliderWith("Size", &w.ortho_size, 0.1, 500, .{ .format = "%.1f m", .logarithmic = true });
                ui.tooltip("Half of how much of the world fits up and down. Ctrl-click to type.", .{});
            }
        }
        if (self.near.has()) {
            ui.setNextItemWidth(200);
            _ = ui.sliderWith("Near clip", &w.near_clip, 0, 1, .{ .format = if (w.near_clip > 0) "%.3f m" else "Game's" });
            ui.tooltip("How close things can be before they're cut away. Lower for close-ups. 0 is the game's.", .{});
        }
        ui.textDisabled("For whichever camera's on screen.", .{});
    }

    fn drawLook(self: *Photo, _: W.Slot.Target) void {
        self.lock.lock();
        defer self.lock.unlock();
        var group: []const u8 = "";
        var any = self.want.no_dof;
        for (items, self.found, &self.want.look, 0..) |item, found, *value, i| {
            if (!found) continue;
            const dof = std.mem.eql(u8, item.group, "Depth of field");
            if (!std.mem.eql(u8, item.group, group)) {
                group = item.group;
                var buf: [64:0]u8 = undefined;
                ui.separatorText(std.fmt.bufPrintSentinel(&buf, "{s}", .{group}, 0) catch "");
                if (dof) {
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
        ui.tooltip("{s} the game's UI, for a clean shot", .{if (on) "Show" else "Hide"});
    }
};

const testing = std.testing;

test "each item's found in each pipeline, scaled to its own range" {
    // Post-Processing v2's lens distortion goes to 100, and its motion blur's an angle
    const v2 = pipelines[2];
    try testing.expectEqual(100, items[11].ref(v2).?.scale);
    try testing.expectEqualStrings("shutterAngle", items[10].ref(v2).?.field);
    try testing.expectEqualStrings("Grain", items[8].ref(v2).?.component);
    // URP and HDRP share names
    try testing.expectEqualStrings("FilmGrain", items[8].ref(pipelines[0]).?.component);
    try testing.expectEqual(1, items[11].ref(pipelines[1]).?.scale);
}
