//! Hands the camera that's on screen to Wraith's free camera just before Unity renders it, once the
//! game's own camera code has had its say, Cinemachine included. Every camera's listed in Photo
//! mode, with the one on screen marked, where the player can switch to another, add one where the
//! view is, or rename one. `Render` calls it on the main thread.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const schema = @import("schema").Unity;

const engine_ = @import("engine.zig");
const Engine = engine_.Engine;
const Object = @import("engine.zig").Object;
const scene_ = @import("scene.zig");
const Scene = scene_.Scene;

const gpa = std.heap.smp_allocator;

const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;
const Mat4 = sdk.math.Mat4;

const log = sdk.log.scoped(.unity);

/// Unity's calls for which camera draws to the screen. Main thread only.
const ViewCalls = struct {
    get_enabled: *const fn (*Object) callconv(.c) bool,
    set_enabled: *const fn (*Object, bool) callconv(.c) void,
    /// Enabled, on a GameObject that's active
    get_active: *const fn (*Object) callconv(.c) bool,
    get_depth: *const fn (*Object) callconv(.c) f32,
    set_depth: *const fn (*Object, f32) callconv(.c) void,
    /// Its `RenderTexture`, or null for the screen
    get_target: *const fn (*Object) callconv(.c) ?*Object,
    set_target: *const fn (*Object, ?*Object) callconv(.c) void,
    /// `CameraClearFlags`: 1 skybox, 2 a colour, 3 just depth, 4 nothing
    get_clear: *const fn (*Object) callconv(.c) i32,
    /// Which layers it draws, a bit each
    get_mask: *const fn (*Object) callconv(.c) i32,

    const names = .{
        .get_clear = .{ "UnityEngine.Camera", "get_clearFlags" },
        .get_mask = .{ "UnityEngine.Camera", "get_cullingMask" },
        .get_enabled = .{ "UnityEngine.Behaviour", "get_enabled" },
        .set_enabled = .{ "UnityEngine.Behaviour", "set_enabled" },
        .get_active = .{ "UnityEngine.Behaviour", "get_isActiveAndEnabled" },
        .get_depth = .{ "UnityEngine.Camera", "get_depth" },
        .set_depth = .{ "UnityEngine.Camera", "set_depth" },
        .get_target = .{ "UnityEngine.Camera", "get_targetTexture" },
        .set_target = .{ "UnityEngine.Camera", "set_targetTexture" },
    };
};

/// Unity's calls for adding a camera, and taking it away again. Main thread only.
const MakeCalls = struct {
    add_component: *const fn (*Object, *Object) callconv(.c) ?*Object,
    /// Its settings and where it is, from another
    copy_from: *const fn (*Object, *Object) callconv(.c) void,
    game_object: *const fn (*Object) callconv(.c) ?*Object,
    destroy: *const fn (*Object, f32) callconv(.c) void,

    const names = .{
        .add_component = .{ "UnityEngine.GameObject", "Internal_AddComponentWithType", "AddComponent" },
        .copy_from = .{ "UnityEngine.Camera", "CopyFrom" },
        .game_object = .{ "UnityEngine.Component", "get_gameObject" },
        .destroy = .{ "UnityEngine.Object", "Destroy" },
    };
};

/// A camera that's on screen because the player switched to it, and what it had before.
const Shown = struct {
    camera: *Object,
    enabled: bool,
    depth: f32,
    texture: ?*Object = null,
    /// On `texture`, while it's off the camera
    hold: u32 = 0,
};

/// One the player added, kept till the plugin stops.
const Added = struct {
    camera: *Object,
    native: usize,
    transform: *Object,
    transform_native: usize,
    hold: u32,
    name: scene_.Name,
};

const Pose = struct {
    position: Vec3,
    rotation: Quat,
    /// Vertical, in degrees, as Unity has it
    fov: f32,
};

/// What the player asked for from Photo mode, on the render thread, for the main thread.
const Asks = struct {
    lock: sdk.sync.RwLock = .{},
    add: bool = false,
    rename: u64 = 0,
    name: scene_.Name = .{},

    fn take(self: *Asks) Asks {
        self.lock.lock();
        defer self.lock.unlock();
        const out: Asks = .{ .add = self.add, .rename = self.rename, .name = self.name };
        self.add = false;
        self.rename = 0;
        return out;
    }
};

pub const Camera = struct {
    engine: *const Engine = undefined,
    /// Wraith's free camera. Null only if Wraith's too old to have one.
    tools: ?W.FreeCamera = null,
    /// Every camera, in Photo mode. Null if Wraith's too old for that.
    list: ?W.ItemList = null,
    managed: ?W.Managed = null,
    /// For finding the one on screen and switching. Null if this Unity's missing them.
    view: ?ViewCalls = null,
    /// For adding one. Null if this Unity's missing them.
    make: ?MakeCalls = null,
    /// `UnityEngine.Camera`'s `System.Type`, for adding one
    camera_type: usize = 0,
    asks: Asks = .{},
    // Main thread only from here down
    /// The game's own camera, as of the last frame it set it.
    game: Pose = undefined,
    /// What we last put on the camera. Null while the game has it.
    wrote: ?Pose = null,
    /// The camera `game` and `wrote` are for.
    steered: ?*Object = null,
    /// The one on screen, or null for the main camera.
    active: ?*Object = null,
    /// Every camera, as of Unity's last answer, which holds them till its next, and the added ones.
    found: std.ArrayList(scene_.Found) = .empty,
    /// What Wraith was last told: native objects, the one on screen, and names.
    listed: std.ArrayList(Listed) = .empty,
    shown: ?Shown = null,
    added: std.ArrayList(Added) = .empty,
    /// The thread Unity calls from, so winding down knows it's there.
    main_thread: std.Thread.Id = 0,
    /// Wound down, so nothing's put back on screen.
    done: bool = false,

    const Listed = struct { native: usize, active: bool, name: scene_.Name };

    /// Blocks while the game's runtime looks, so not on the render thread.
    pub fn start(self: *Camera, engine: *const Engine, managed: ?W.Managed) void {
        self.engine = engine;
        self.managed = managed;
        const root = sdk.wraith.root() orelse return;
        self.tools = root.camera();
        const t = self.tools.?;
        t.setWorld(.{ .up = .pos_y, .look = .pos_z, .left_handed = true, .metre = 1 });
        const m = managed orelse return;
        var missing: []const u8 = "";
        self.view = engine_.findCalls(ViewCalls, ViewCalls.names, m, &missing) catch blk: {
            log.info("Can't tell which camera's on screen or switch, since this Unity's missing {s}", .{missing});
            break :blk null;
        };
        self.make = engine_.findCalls(MakeCalls, MakeCalls.names, m, &missing) catch blk: {
            log.info("Can't add cameras, since this Unity's missing {s}", .{missing});
            break :blk null;
        };
        self.camera_type = m.typeObject("UnityEngine.Camera") catch 0;
        const can_add = self.make != null and self.camera_type != 0;
        const list = t.cameras(if (can_add) W.ItemList.Add.init(self, onAdd) else null, W.ItemList.Rename.init(self, onRename));
        // Wraith's too old for it
        if (list.table != null) self.list = list;
    }

    pub fn deinit(self: *Camera) void {
        if (self.shown != null or self.added.items.len > 0) log.info("Unity's camera wasn't put back, since the plugin stopped without winding down", .{});
        if (self.managed) |m| {
            if (self.shown) |s| if (s.hold != 0) m.release(s.hold);
            for (self.added.items) |a| m.release(a.hold);
        }
        self.shown = null;
        self.found.deinit(gpa);
        self.listed.deinit(gpa);
        self.added.deinit(gpa);
    }

    // From Photo mode's buttons, on the render thread

    fn onAdd(self: *Camera) void {
        self.asks.lock.lock();
        defer self.asks.lock.unlock();
        self.asks.add = true;
    }

    fn onRename(self: *Camera, id: u64, name: []const u8) void {
        self.asks.lock.lock();
        defer self.asks.lock.unlock();
        self.asks.rename = id;
        self.asks.name = .init(name);
    }

    /// The camera to steer this frame: the one on screen, or else the main camera.
    pub fn target(self: *const Camera) ?*Object {
        return self.active orelse self.engine.main_camera();
    }

    /// Main thread, once a frame before any camera renders. Does what the player asked, puts the
    /// camera they want on screen, finds the one that is, and lists them for Wraith when they've
    /// changed.
    pub fn pick(self: *Camera, scene: ?*Scene) void {
        self.main_thread = std.Thread.getCurrentId();
        if (self.done) return;
        const list = self.list orelse return;
        const s = scene orelse return;
        self.find(s);
        const asks = self.asks.take();
        if (asks.add) self.add(s, list);
        if (asks.rename != 0) self.rename(s, asks.rename, asks.name.get());
        self.follow(if (self.tools) |t| t.wantedCamera() else 0);
        self.active = self.onScreen();
        if (self.changed(s)) self.tell(s, list) catch {};
    }

    /// Every camera Unity has, and the added ones, which it may not list while they're off.
    fn find(self: *Camera, s: *Scene) void {
        self.found.clearRetainingCapacity();
        _ = s.objectsOfType(gpa, "UnityEngine.Camera", &self.found) catch {};
        var i: usize = 0;
        while (i < self.added.items.len) {
            const a = self.added.items[i];
            if (!s.alive(a.camera, a.native)) {
                if (self.managed) |m| m.release(a.hold);
                _ = self.added.swapRemove(i);
                continue;
            }
            i += 1;
            if (self.isFound(a.camera)) continue;
            self.found.append(gpa, .{ .object = a.camera, .native = a.native, .transform = a.transform, .transform_native = a.transform_native, .name = a.name, .position = .{} }) catch {};
        }
    }

    fn isFound(self: *const Camera, camera: *Object) bool {
        for (self.found.items) |f| if (f.object == camera) return true;
        return false;
    }

    fn objectOf(self: *const Camera, native: u64) ?*Object {
        for (self.found.items) |f| if (f.native == native) return f.object;
        return null;
    }

    /// The camera the world's seen through: the one the player switched to, or else the game's
    /// main camera, the first that's on and tagged MainCamera. That's right even when it draws to a
    /// texture that another camera shows, like pixel-art games do. Games that tag none get the
    /// deepest that's on, draws to the screen and starts it afresh, and draws more than UI, so
    /// overlays like a UI camera that only clears depth don't count.
    fn onScreen(self: *const Camera) ?*Object {
        if (self.shown) |s| if (self.isFound(s.camera)) return s.camera;
        if (self.engine.main_camera()) |main| return main;
        const calls = self.view orelse return null;
        var best: ?*Object = null;
        var depth: f32 = 0;
        for (self.found.items) |f| {
            if (!seesWorld(calls, f.object)) continue;
            const d = calls.get_depth(f.object);
            if (best != null and d < depth) continue;
            best = f.object;
            depth = d;
        }
        return best;
    }

    /// The layer Unity puts UI on.
    const ui_layer: i32 = 1 << 5;

    fn seesWorld(calls: ViewCalls, camera: *Object) bool {
        if (!calls.get_active(camera) or calls.get_target(camera) != null) return false;
        const clear = calls.get_clear(camera);
        if (clear != 1 and clear != 2) return false;
        return calls.get_mask(camera) & ~ui_layer != 0;
    }

    /// What Wraith says to put on screen, from Follow selection: `native`, or the game's own for 0.
    fn follow(self: *Camera, native: u64) void {
        if (native != 0) return self.switchTo(native);
        const calls = self.view orelse return;
        const s = self.shown orelse return;
        self.putBack(calls, s);
        self.shown = null;
    }

    /// Puts the last one the player switched to back, then `native` on screen, unless it's there
    /// once that's done.
    fn switchTo(self: *Camera, native: u64) void {
        const calls = self.view orelse return;
        const want = self.objectOf(native) orelse return;
        if (self.shown) |s| {
            if (s.camera == want) return;
            self.putBack(calls, s);
            self.shown = null;
        }
        if (self.onScreen() == want) return;
        self.showOnScreen(want);
    }

    /// Puts `want` on screen, and the last one back as it was. Null for the game's own.
    fn showOnScreen(self: *Camera, want: ?*Object) void {
        const calls = self.view orelse return;
        if (self.shown) |s| {
            if (s.camera == want) return;
            self.putBack(calls, s);
            self.shown = null;
        }
        const camera = want orelse return;
        var s: Shown = .{ .camera = camera, .enabled = calls.get_enabled(camera), .depth = calls.get_depth(camera) };
        // A texture comes off, so it draws to the screen. Held meanwhile, so the collector leaves it be
        if (calls.get_target(camera)) |texture| {
            const m = self.managed orelse return;
            s.hold = m.hold(@intFromPtr(texture)) catch return;
            s.texture = texture;
            calls.set_target(camera, null);
        }
        // Over every other camera, so it's what's seen
        var top = s.depth;
        for (self.found.items) |f| if (f.object != camera) {
            top = @max(top, calls.get_depth(f.object) + 1);
        };
        if (top != s.depth) calls.set_depth(camera, top);
        if (!s.enabled) calls.set_enabled(camera, true);
        self.shown = s;
    }

    fn putBack(self: *Camera, calls: ViewCalls, s: Shown) void {
        if (self.reachable(s.camera)) {
            calls.set_depth(s.camera, s.depth);
            if (!s.enabled) calls.set_enabled(s.camera, false);
            if (s.texture) |t| calls.set_target(s.camera, t);
        }
        if (s.hold != 0) if (self.managed) |m| m.release(s.hold);
    }

    /// A new camera where the view is, like the one on screen, off till the player switches to it.
    fn add(self: *Camera, s: *Scene, list: W.ItemList) void {
        const make = self.make orelse return;
        const view = self.view orelse return;
        const m = self.managed orelse return;
        const from = self.target() orelse return;
        var name_buf: [32]u8 = undefined;
        const name = std.fmt.bufPrint(&name_buf, "Wraith camera {d}", .{self.added.items.len + 1}) catch "Wraith camera";
        const made = m.invoke("UnityEngine.GameObject", ".ctor", 0, &.{.{ .kind = .text, .flag = false, .integer = 0, .number = 0, .text = name, .object = 0 }}) catch |err| {
            log.warn("Couldn't make a GameObject for a camera: {t}", .{err});
            return;
        };
        if (made.object == 0) return;
        const go: *Object = @ptrFromInt(made.object);
        const camera = make.add_component(go, @ptrFromInt(self.camera_type)) orelse {
            log.warn("Couldn't add a Camera to its GameObject", .{});
            make.destroy(go, 0);
            return;
        };
        make.copy_from(camera, from);
        // Whatever the one it's like drew to, it's the screen's till it's switched to
        view.set_target(camera, null);
        view.set_enabled(camera, false);
        const hold = m.hold(@intFromPtr(camera)) catch {
            make.destroy(go, 0);
            return;
        };
        const transform = self.engine.transform(camera) orelse {
            m.release(hold);
            make.destroy(go, 0);
            return;
        };
        const added: Added = .{ .camera = camera, .native = s.nativeOf(camera), .transform = transform, .transform_native = s.nativeOf(transform), .hold = hold, .name = .init(name) };
        self.added.append(gpa, added) catch {
            m.release(hold);
            make.destroy(go, 0);
            return;
        };
        self.found.append(gpa, .{ .object = camera, .native = added.native, .transform = transform, .transform_native = added.transform_native, .name = added.name, .position = .{} }) catch {};
        self.tell(s, list) catch {};
        list.select(added.native);
    }

    fn rename(self: *Camera, s: *Scene, native: u64, name: []const u8) void {
        const m = self.managed orelse return;
        for (self.found.items) |*f| if (f.native == native) {
            _ = m.invoke("UnityEngine.Object", "set_name", @intFromPtr(f.object), &.{.{ .kind = .text, .flag = false, .integer = 0, .number = 0, .text = name, .object = 0 }}) catch |err| {
                log.warn("Couldn't rename a camera: {t}", .{err});
                return;
            };
            f.name = .init(name);
            s.rename(f.native, f.transform_native, name);
            for (self.added.items) |*a| if (a.native == native) {
                a.name = .init(name);
            };
            return;
        };
    }

    /// Whether `found` isn't what Wraith was last told.
    fn changed(self: *const Camera, s: *Scene) bool {
        if (self.found.items.len != self.listed.items.len) return true;
        const active_native = if (self.active) |a| s.nativeOf(a) else 0;
        for (self.found.items, self.listed.items) |f, l| {
            if (f.native != l.native or (f.native == active_native) != l.active) return true;
            if (!std.mem.eql(u8, f.name.get(), l.name.get())) return true;
        }
        return false;
    }

    /// The one on screen first, then the rest as Unity has them.
    fn tell(self: *Camera, s: *Scene, list: W.ItemList) !void {
        const active_native = if (self.active) |a| s.nativeOf(a) else 0;
        const main_native = if (self.engine.main_camera()) |c| s.nativeOf(c) else 0;
        for (self.found.items, 0..) |f, i| if (f.native == active_native) {
            std.mem.swap(scene_.Found, &self.found.items[0], &self.found.items[i]);
            break;
        };
        self.listed.clearRetainingCapacity();
        var items: std.ArrayList(W.ItemList.Item) = .empty;
        defer items.deinit(gpa);
        for (self.found.items) |*f| {
            try self.listed.append(gpa, .{ .native = f.native, .active = f.native == active_native, .name = f.name });
            const detail = if (self.isAdded(f.native)) "Added in Photo mode" else if (f.native == main_native) "The main camera" else "";
            try items.append(gpa, .{ .id = f.native, .name = f.name.get(), .detail = detail, .current = f.native == active_native });
        }
        list.set(items.items);
    }

    fn isAdded(self: *const Camera, native: usize) bool {
        for (self.added.items) |a| if (a.native == native) return true;
        return false;
    }

    /// Main thread, as the plugin's about to stop: puts the game's camera back as it was, and takes
    /// away the ones the player added. Does nothing anywhere else, where Unity's calls aren't safe.
    pub fn windDown(self: *Camera) void {
        if (self.main_thread == 0 or std.Thread.getCurrentId() != self.main_thread) {
            log.info("Not on Unity's main thread, so its cameras are left as they are", .{});
            return;
        }
        self.done = true;
        if (self.shown) |s| if (self.view) |calls| {
            self.putBack(calls, s);
            self.shown = null;
        };
        if (self.wrote != null) if (self.steered) |cam| if (self.reachable(cam)) if (self.engine.transform(cam)) |t| write(self.engine, cam, t, self.game);
        self.wrote = null;
        if (self.make) |make| for (self.added.items) |a| {
            if (make.game_object(a.camera)) |go| make.destroy(go, 0);
        };
        if (self.managed) |m| for (self.added.items) |a| m.release(a.hold);
        self.added.clearRetainingCapacity();
        self.active = null;
    }

    /// Main thread, as a camera's about to render.
    pub fn steer(self: *Camera, camera: *Object) void {
        if (self.done) return;
        self.steerWith(self.tools orelse return, camera);
    }

    /// `tools` is the free camera, or a stand-in for tests.
    fn steerWith(self: *Camera, tools: anytype, camera: *Object) void {
        const e = self.engine;
        // Not UI cameras, reflections and the like, only what's on screen
        if (self.target() != camera) return;
        if (self.steered != camera) self.handOver(camera);
        const transform = e.transform(camera) orelse return;
        const now = read(e, camera, transform);
        // Whatever's unchanged since we wrote it, the game didn't set, so its own is as it was.
        // Games often set where the camera is every frame but leave its fov alone
        if (self.wrote) |w| {
            if (!std.meta.eql(now.position, w.position)) self.game.position = now.position;
            if (!std.meta.eql(now.rotation, w.rotation)) self.game.rotation = now.rotation;
            if (now.fov != w.fov) self.game.fov = now.fov;
        } else self.game = now;

        var state: W.FreeCamera.State = .{
            .position = self.game.position,
            .aim = .rotation,
            .target = .{},
            .up = .{ .y = 1 },
            .rotation = self.game.rotation,
            .roll = 0,
            .fov = std.math.degreesToRadians(self.game.fov),
        };
        const before = state;
        tools.camera(self.idOf(camera), &state);
        if (std.meta.eql(state, before)) {
            // The free camera let go. Put the game's back, for games that don't set it every frame
            if (self.wrote != null) write(e, camera, transform, self.game);
            self.wrote = null;
            return;
        }
        write(e, camera, transform, .{ .position = state.position, .rotation = state.rotation, .fov = std.math.radiansToDegrees(state.fov) });
        // Read back, since Unity tidies what it's given, like normalizing the rotation
        self.wrote = read(e, camera, transform);
    }

    /// To another camera. The last one gets back what the game had on it, if it's still around,
    /// unless the player added it, which stays put.
    fn handOver(self: *Camera, camera: *Object) void {
        const e = self.engine;
        if (self.wrote != null) if (self.steered) |old| {
            if (!self.isAddedCamera(old) and self.reachable(old)) if (e.transform(old)) |t| write(e, old, t, self.game);
        };
        self.wrote = null;
        self.steered = camera;
    }

    /// Its id in Wraith's list, its native object, so a cut to another tells the free camera to
    /// carry on from there.
    fn idOf(self: *const Camera, camera: *Object) u64 {
        for (self.found.items) |f| if (f.object == camera) return f.native;
        // Not listed, like without a list, which needs one that stays the same
        return @intFromPtr(camera);
    }

    fn isAddedCamera(self: *const Camera, camera: *Object) bool {
        for (self.added.items) |a| if (a.camera == camera) return true;
        return false;
    }

    /// Still a camera Unity has, so it's safe to call on.
    fn reachable(self: *const Camera, camera: *Object) bool {
        if (self.engine.main_camera() == camera) return true;
        for (self.found.items) |f| if (f.object == camera) return true;
        return false;
    }
};

fn read(e: *const Engine, camera: *Object, transform: *Object) Pose {
    var pose: Pose = .{ .position = .{}, .rotation = .identity, .fov = e.get_fov(camera) };
    e.get_position(transform, &pose.position);
    e.get_rotation(transform, &pose.rotation);
    return pose;
}

fn write(e: *const Engine, camera: *Object, transform: *Object, pose: Pose) void {
    e.set_position(transform, &pose.position);
    e.set_rotation(transform, &pose.rotation);
    e.set_fov(camera, pose.fov);
}

/// Main thread, once the free camera has had its say, so plugins drawing over the world, like posing
/// and the Scene panel's gizmo, see it the way it's drawn.
pub fn publishView(e: *const Engine, camera: *Object) void {
    var view: Mat4 = .identity;
    var projection: Mat4 = .identity;
    e.world_to_camera(camera, &view);
    e.projection(camera, &projection);
    const d3d = toD3d(view, projection);
    sdk.frame.setView(d3d.view, d3d.projection);
}

/// Unity's view is mirrored, from its left-handed world to an OpenGL camera that looks down -z with
/// depth from -1 to 1. The gizmo works out which half of its rings faces the camera from the view
/// and projection, and gets it backwards for that mix, so it'd draw the back halves while picking the
/// front ones. This gives it D3D's way round, looking down +z with depth from 0 to 1, like most
/// games. The two together still put everything in the same place on screen.
fn toD3d(view: Mat4, projection: Mat4) struct { view: Mat4, projection: Mat4 } {
    const flip: Mat4 = .scaling(.{ .x = 1, .y = 1, .z = -1 });
    // z' = (z + w) / 2
    var depth: Mat4 = .identity;
    depth.m[10] = 0.5;
    depth.m[14] = 0.5;
    return .{ .view = view.mul(flip), .projection = flip.mul(projection).mul(depth) };
}

const testing = std.testing;

/// A camera the game sets, or not, and what's been written to it.
const FakeGame = struct {
    var pose: Pose = .{ .position = .{ .x = 1 }, .rotation = .identity, .fov = 60 };
    var writes: u32 = 0;
    const camera: *Object = @ptrFromInt(0x1000);
    const transform: *Object = @ptrFromInt(0x2000);

    fn mainCamera() callconv(.c) ?*Object {
        return camera;
    }
    fn transformOf(_: *Object) callconv(.c) ?*Object {
        return transform;
    }
    fn getPosition(_: *Object, out: *Vec3) callconv(.c) void {
        out.* = pose.position;
    }
    fn setPosition(_: *Object, in: *const Vec3) callconv(.c) void {
        pose.position = in.*;
        writes += 1;
    }
    fn getRotation(_: *Object, out: *Quat) callconv(.c) void {
        out.* = pose.rotation;
    }
    fn setRotation(_: *Object, in: *const Quat) callconv(.c) void {
        pose.rotation = in.*;
    }
    fn getFov(_: *Object) callconv(.c) f32 {
        return pose.fov;
    }
    fn setFov(_: *Object, fov: f32) callconv(.c) void {
        pose.fov = fov;
    }
    fn frameCount() callconv(.c) i32 {
        return 1;
    }
    fn matrix(_: *Object, out: *Mat4) callconv(.c) void {
        out.* = .identity;
    }

    const engine: Engine = .{
        .main_camera = mainCamera,
        .transform = transformOf,
        .get_position = getPosition,
        .set_position = setPosition,
        .get_rotation = getRotation,
        .set_rotation = setRotation,
        .get_fov = getFov,
        .set_fov = setFov,
        .frame_count = frameCount,
        .world_to_camera = matrix,
        .projection = matrix,
        .local_to_world = matrix,
    };
};

/// The free camera: hands back its own camera while it's on.
const FakeTools = struct {
    on: bool = false,
    position: Vec3 = .{ .x = 9 },
    fov: f32 = std.math.degreesToRadians(90),
    /// What the game had, as it came in
    seen: Vec3 = .{},

    pub fn camera(self: *FakeTools, _: u64, state: *W.FreeCamera.State) void {
        self.seen = state.position;
        if (!self.on) return;
        state.position = self.position;
        state.fov = self.fov;
    }
};

test "moves the main camera while the free camera has it, and gives the game's back" {
    var cam: Camera = .{ .engine = &FakeGame.engine };
    var tools: FakeTools = .{};
    FakeGame.writes = 0;

    // Off, the game's camera is left alone
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(0, FakeGame.writes);
    try testing.expectEqual(1, tools.seen.x);

    // On, it's the free camera's, with its fov in degrees
    tools.on = true;
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(9, FakeGame.pose.position.x);
    try testing.expectApproxEqAbs(90, FakeGame.pose.fov, 0.001);

    // A game that sets its camera every frame still shows the free camera where it is
    FakeGame.pose.position = .{ .x = 2 };
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(2, tools.seen.x);
    try testing.expectEqual(9, FakeGame.pose.position.x);

    // One that doesn't still has its last own pose, not ours
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(2, tools.seen.x);

    // Let go, the game gets its camera back as it was
    tools.on = false;
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(2, FakeGame.pose.position.x);
    try testing.expectApproxEqAbs(60, FakeGame.pose.fov, 0.001);
    const writes = FakeGame.writes;
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(writes, FakeGame.writes);
}

test "a picked camera takes over, and the one before gets the game's back" {
    var cam: Camera = .{ .engine = &FakeGame.engine };
    var tools: FakeTools = .{ .on = true };
    FakeGame.pose = .{ .position = .{ .x = 1 }, .rotation = .identity, .fov = 60 };
    FakeGame.writes = 0;
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(9, FakeGame.pose.position.x);
    try testing.expectEqual(1, FakeGame.writes);

    // Picked, so the main camera's left alone
    const other: *Object = @ptrFromInt(0x3000);
    cam.active = other;
    try testing.expectEqual(other, cam.target().?);
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(1, FakeGame.writes);

    // The main camera gets the game's back, then the picked one's the free camera's, from its own
    cam.steerWith(&tools, other);
    try testing.expectEqual(3, FakeGame.writes);
    try testing.expectEqual(1, tools.seen.x);
    try testing.expectEqual(9, FakeGame.pose.position.x);
    try testing.expectEqual(other, cam.steered.?);
}

test "other cameras are left alone" {
    var cam: Camera = .{ .engine = &FakeGame.engine };
    var tools: FakeTools = .{ .on = true };
    FakeGame.writes = 0;
    cam.steerWith(&tools, @ptrFromInt(0x3000));
    try testing.expectEqual(0, FakeGame.writes);
}

test "Unity's camera goes to D3D's way round, landing in the same place" {
    // OpenGL's perspective, row-vector style, as Unity's memory reads
    const n: f32 = 0.5;
    const f: f32 = 100;
    const a = -(f + n) / (f - n);
    const b = -2 * f * n / (f - n);
    const gl: Mat4 = .{ .m = .{ 1.5, 0, 0, 0, 0, 2, 0, 0, 0, 0, a, -1, 0, 0, b, 0 } };
    // Unity's world is left-handed, so its view mirrors z on the way to the camera's
    const view = Mat4.translation(.{ .x = -3 }).mul(.scaling(.{ .x = 1, .y = 1, .z = -1 }));
    const d3d = toD3d(view, gl);

    // No mirror left, and the projection's D3D's way round, which is what the gizmo goes by
    const v = d3d.view;
    const det = v.at(0, 0) * (v.at(1, 1) * v.at(2, 2) - v.at(1, 2) * v.at(2, 1)) -
        v.at(0, 1) * (v.at(1, 0) * v.at(2, 2) - v.at(1, 2) * v.at(2, 0)) +
        v.at(0, 2) * (v.at(1, 0) * v.at(2, 1) - v.at(1, 1) * v.at(2, 0));
    try testing.expect(det > 0);
    try testing.expect(d3d.projection.at(2, 3) > 0);

    // In front of the camera, which is +z in Unity's world
    const p: Vec3 = .{ .x = 4, .y = 1, .z = 5 };
    try testing.expect(d3d.view.transformPoint(p).z > 0);
    // Same spot on screen
    const before = view.mul(gl).transformPoint(p);
    const after = d3d.view.mul(d3d.projection).transformPoint(p);
    try testing.expectApproxEqAbs(before.x, after.x, 1e-5);
    try testing.expectApproxEqAbs(before.y, after.y, 1e-5);
    // Depth from 0 at the near plane to 1 at the far one
    const vp = d3d.view.mul(d3d.projection);
    try testing.expectApproxEqAbs(0, vp.transformPoint(.{ .x = 3, .z = n }).z, 1e-4);
    try testing.expectApproxEqAbs(1, vp.transformPoint(.{ .x = 3, .z = f }).z, 1e-4);
}

/// Two cameras' enabled, depth and target, as Unity has them.
const FakeView = struct {
    const picked: *Object = @ptrFromInt(0x3000);
    const other: *Object = @ptrFromInt(0x4000);
    /// Deeper than both, drawing only UI over them
    const ui: *Object = @ptrFromInt(0x6000);
    var enabled: bool = false;
    var depth: f32 = 0;
    var texture: ?*Object = null;

    fn getEnabled(_: *Object) callconv(.c) bool {
        return enabled;
    }
    fn setEnabled(_: *Object, on: bool) callconv(.c) void {
        enabled = on;
    }
    /// The other one's always on
    fn getActive(o: *Object) callconv(.c) bool {
        return o != picked or enabled;
    }
    fn getDepth(o: *Object) callconv(.c) f32 {
        return if (o == picked) depth else if (o == ui) 10 else 5;
    }
    fn getClear(o: *Object) callconv(.c) i32 {
        return if (o == ui) 3 else 1;
    }
    fn getMask(o: *Object) callconv(.c) i32 {
        return if (o == ui) Camera.ui_layer else -1;
    }
    fn setDepth(_: *Object, d: f32) callconv(.c) void {
        depth = d;
    }
    fn getTarget(_: *Object) callconv(.c) ?*Object {
        return texture;
    }
    fn setTarget(_: *Object, t: ?*Object) callconv(.c) void {
        texture = t;
    }

    const calls: ViewCalls = .{
        .get_enabled = getEnabled,
        .set_enabled = setEnabled,
        .get_active = getActive,
        .get_depth = getDepth,
        .set_depth = setDepth,
        .get_target = getTarget,
        .set_target = setTarget,
        .get_clear = getClear,
        .get_mask = getMask,
    };

    fn noMain() callconv(.c) ?*Object {
        return null;
    }

    /// For a game that tags no main camera
    const engine: Engine = blk: {
        var e = FakeGame.engine;
        e.main_camera = noMain;
        break :blk e;
    };

    fn found(object: *Object) scene_.Found {
        return .{ .object = object, .native = @intFromPtr(object), .transform = object, .transform_native = 1, .name = .init("Camera"), .position = .{} };
    }
};

test "a picked camera goes on screen over the others, and back as it was after" {
    var cam: Camera = .{ .engine = &FakeView.engine, .view = FakeView.calls };
    defer cam.found.deinit(testing.allocator);
    try cam.found.appendSlice(testing.allocator, &.{ FakeView.found(FakeView.other), FakeView.found(FakeView.picked) });
    FakeView.enabled = false;
    FakeView.depth = 0;
    FakeView.texture = null;

    cam.showOnScreen(FakeView.picked);
    try testing.expect(FakeView.enabled);
    try testing.expectEqual(6, FakeView.depth);
    // Already there
    cam.showOnScreen(FakeView.picked);
    try testing.expectEqual(6, FakeView.depth);

    cam.showOnScreen(null);
    try testing.expect(!FakeView.enabled);
    try testing.expectEqual(0, FakeView.depth);
    try testing.expectEqual(null, cam.shown);

    // One that draws to a texture is left be without the game's runtime to hold it
    FakeView.texture = @ptrFromInt(0x5000);
    cam.showOnScreen(FakeView.picked);
    try testing.expect(!FakeView.enabled);
    try testing.expectEqual(null, cam.shown);
}

test "the camera on screen is the deepest that's on and draws to the screen, and switching swaps it" {
    var cam: Camera = .{ .engine = &FakeView.engine, .view = FakeView.calls };
    defer cam.found.deinit(testing.allocator);
    try cam.found.appendSlice(testing.allocator, &.{ FakeView.found(FakeView.other), FakeView.found(FakeView.picked) });
    FakeView.enabled = false;
    FakeView.depth = 0;
    FakeView.texture = null;

    // The picked one's off, so it's the other
    try testing.expectEqual(FakeView.other, cam.onScreen().?);

    cam.switchTo(@intFromPtr(FakeView.picked));
    try testing.expectEqual(FakeView.picked, cam.onScreen().?);
    try testing.expectEqual(6, FakeView.depth);

    // Back to the game's own, which is on screen again once the picked one's put back
    cam.switchTo(@intFromPtr(FakeView.other));
    try testing.expectEqual(null, cam.shown);
    try testing.expect(!FakeView.enabled);
    try testing.expectEqual(0, FakeView.depth);
    try testing.expectEqual(FakeView.other, cam.onScreen().?);

    // Not one of Unity's
    cam.switchTo(0x9999);
    try testing.expectEqual(null, cam.shown);
}

test "a UI camera drawn over the world isn't the one on screen, however deep it is" {
    var cam: Camera = .{ .engine = &FakeView.engine, .view = FakeView.calls };
    defer cam.found.deinit(testing.allocator);
    try cam.found.appendSlice(testing.allocator, &.{ FakeView.found(FakeView.ui), FakeView.found(FakeView.other), FakeView.found(FakeView.picked) });
    FakeView.enabled = false;
    FakeView.depth = 0;
    FakeView.texture = null;
    try testing.expectEqual(FakeView.other, cam.onScreen().?);
    // Switched to, it's over the UI camera too, and counts
    cam.switchTo(@intFromPtr(FakeView.picked));
    try testing.expectEqual(11, FakeView.depth);
    try testing.expectEqual(FakeView.picked, cam.onScreen().?);
    cam.showOnScreen(null);
}

test "the game's main camera is the one on screen, even under a deeper one, till another's switched to" {
    var cam: Camera = .{ .engine = &FakeGame.engine, .view = FakeView.calls };
    defer cam.found.deinit(testing.allocator);
    try cam.found.appendSlice(testing.allocator, &.{ FakeView.found(FakeView.other), FakeView.found(FakeGame.camera), FakeView.found(FakeView.picked) });
    FakeView.enabled = false;
    FakeView.depth = 0;
    FakeView.texture = null;
    try testing.expectEqual(FakeGame.camera, cam.onScreen().?);
    cam.switchTo(@intFromPtr(FakeView.picked));
    try testing.expectEqual(FakeView.picked, cam.onScreen().?);
    // Back to the main camera, which needs nothing more
    cam.switchTo(@intFromPtr(FakeGame.camera));
    try testing.expectEqual(null, cam.shown);
    try testing.expectEqual(FakeGame.camera, cam.onScreen().?);
}

test "a camera the player added stays where it was put when the free camera leaves it" {
    var cam: Camera = .{ .engine = &FakeGame.engine };
    defer cam.added.deinit(testing.allocator);
    try cam.added.append(testing.allocator, .{ .camera = FakeGame.camera, .native = 1, .transform = FakeGame.transform, .transform_native = 2, .hold = 0, .name = .init("Wraith camera 1") });
    var tools: FakeTools = .{ .on = true };
    FakeGame.pose = .{ .position = .{ .x = 1 }, .rotation = .identity, .fov = 60 };
    FakeGame.writes = 0;
    cam.steerWith(&tools, FakeGame.camera);
    try testing.expectEqual(1, FakeGame.writes);

    // Off to another: nothing's written back to the added one, only the free camera's to the new one
    const other: *Object = @ptrFromInt(0x3000);
    cam.active = other;
    // Where the other one is, as the fake has one pose for both
    FakeGame.pose.position = .{ .x = 2 };
    cam.steerWith(&tools, other);
    try testing.expectEqual(2, FakeGame.writes);
    try testing.expectEqual(other, cam.steered.?);
}
