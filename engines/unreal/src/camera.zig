//! Hands the player's camera to Wraith's free camera through a camera modifier of our own. The camera
//! manager runs its modifiers last thing each frame, after the game's own camera code, cutscene
//! cameras included, and each one's `BlueprintModifyCamera` goes through `ProcessEvent` with the
//! camera as it is and room for a new one. So ours sees the game's camera and, while the free
//! camera has it, gives back its own instead.
//!
//! Photo mode lists the cameras: the game's own, every camera actor in the level, and any the player
//! added. With Follow selection on, ours shows the view from the one picked instead, so the game's
//! view target's never touched. Added ones are views of our own, not actors, so nothing's left in
//! the world when the plugin goes.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const schema = @import("schema").Unreal;

const Unreal = @import("ue/Unreal.zig");
const World = @import("ue/World.zig");
const Loop = @import("loop.zig").Loop;

const Vec3 = sdk.math.Vec3;
const Quat = sdk.math.Quat;
const Mat4 = sdk.math.Mat4;

const log = sdk.log.scoped(.unreal);
const gpa = std.heap.smp_allocator;

/// Unreal's units are centimetres.
const metre = 100;
const near = 10;
const far = 1_000_000;

/// The game's own camera in the list, whatever it's looking through.
const game_id: u64 = 1;
/// Added ones count up from here. Camera actors are their addresses, far above.
const first_added: u64 = 2;

pub const Pose = struct {
    position: Vec3,
    rotation: Quat,
    /// Horizontal, in degrees, as Unreal has it.
    fov: f32,
};

pub const Offsets = struct {
    /// `PlayerController.PlayerCameraManager`.
    manager: usize,
    /// `CameraModifier`, the plain kind ours is.
    modifier_class: usize,
    /// `PlayerCameraManager.AddNewCameraModifier` and its `ModifierClass` and `ReturnValue`.
    add: usize,
    add_size: usize,
    add_class: usize,
    add_returns: usize,
    /// `PlayerCameraManager.RemoveCameraModifier` and its `ModifierToRemove`, for going.
    remove: ?usize = null,
    remove_size: usize = 0,
    remove_param: usize = 0,
    /// `CameraModifier.BlueprintModifyCamera` and its params, the camera as it is then the new one.
    modify: usize,
    in_location: usize,
    in_rotation: usize,
    in_fov: usize,
    out_location: usize,
    out_rotation: usize,
    out_fov: usize,
    /// For seeing through the level's cameras. Null if this Unreal's missing something they need.
    views: ?Views = null,
};

/// What it takes to see through a camera actor.
pub const Views = struct {
    /// `CameraActor`, cine cameras included.
    actor: usize,
    /// `CameraActor.CameraComponent`.
    component: usize,
    /// `CameraComponent.FieldOfView`, horizontal.
    fov: usize,
    /// `SceneComponent.K2_GetComponentLocation` and `K2_GetComponentRotation`, with their `ReturnValue`.
    location: Unreal.Call,
    rotation: Unreal.Call,

    fn find(ue: *const Unreal, missing: *[]const u8) !Views {
        const names = [_][]const u8{ "CameraActor", "CameraComponent", "SceneComponent" };
        var found: [names.len]usize = undefined;
        ue.findIn("/Script/Engine", &names, &found);
        for (names, found) |n, f| if (f == 0) {
            missing.* = n;
            return error.MissingClass;
        };
        const actor, const component, const scene = found;
        return .{
            .actor = actor,
            .component = ue.offsetOf(actor, "CameraComponent") orelse {
                missing.* = "CameraComponent";
                return error.MissingProperty;
            },
            .fov = ue.offsetOf(component, "FieldOfView") orelse {
                missing.* = "FieldOfView";
                return error.MissingProperty;
            },
            .location = try ue.callOf(scene, "K2_GetComponentLocation", &.{"ReturnValue"}, missing),
            .rotation = try ue.callOf(scene, "K2_GetComponentRotation", &.{"ReturnValue"}, missing),
        };
    }
};

/// A camera's name, kept with it.
const Name = struct {
    buf: [64]u8 = undefined,
    len: u8 = 0,

    fn init(text: []const u8) Name {
        var n: Name = .{};
        const len = @min(text.len, n.buf.len);
        @memcpy(n.buf[0..len], text[0..len]);
        n.len = @intCast(len);
        return n;
    }

    fn get(self: *const Name) []const u8 {
        return self.buf[0..self.len];
    }
};

/// What the player asked for from Photo mode, on the render thread, for the game thread.
const Asks = struct {
    lock: sdk.sync.RwLock = .{},
    add: bool = false,
    rename: u64 = 0,
    name: Name = .{},

    fn take(self: *Asks) Asks {
        self.lock.lock();
        defer self.lock.unlock();
        const out: Asks = .{ .add = self.add, .rename = self.rename, .name = self.name };
        self.add = false;
        self.rename = 0;
        return out;
    }
};

/// One found in the look that's going on, and its slot in the object array.
const Found = struct { actor: usize, slot: u32 };

/// A camera actor in the level.
const Level = struct { actor: usize, slot: u32, name: Name };

/// One the player added: where it is, kept as the free camera moves it.
const Added = struct { id: u64, pose: Pose, name: Name };

/// A name the player gave the game's camera or a camera actor, which keep theirs otherwise.
const Renamed = struct { id: u64, name: Name };

const Listed = struct {
    id: u64,
    current: bool,
    name: Name,
    detail: []const u8,

    fn same(a: []const Listed, b: []const Listed) bool {
        if (a.len != b.len) return false;
        for (a, b) |x, y| {
            if (x.id != y.id or x.current != y.current or !std.mem.eql(u8, x.name.get(), y.name.get())) return false;
        }
        return true;
    }
};

/// Objects looked through a tick for camera actors, so no one frame takes the lot.
const scan_per_tick = 8 * 1024;

pub const Camera = struct {
    world: *const World = undefined,
    loop: *Loop = undefined,
    off: Offsets = undefined,
    /// Wraith's free camera. Null only if Wraith's too old to have one.
    tools: ?W.FreeCamera = null,
    /// Every camera, in Photo mode. Null if Wraith's too old for that.
    list: ?W.ItemList = null,
    asks: Asks = .{},
    // Game thread only from here down
    /// The camera manager ours is in, and ours, with their slots in the object array.
    manager: usize = 0,
    modifier: usize = 0,
    manager_slot: u32 = 0,
    modifier_slot: u32 = 0,
    /// Said so once, since each level load brings a new manager.
    added_modifier: bool = false,
    /// The camera as it was last shown, for what's nearest it.
    shown: ?Pose = null,
    /// Runs once the camera's updated, the last thing before the frame's sent to be drawn.
    late: ?Loop.Callback = null,
    /// The one shown: `game_id`, a camera actor's address, or an added one's id.
    active: u64 = game_id,
    /// Camera actors as of the last full look.
    level: std.ArrayList(Level) = .empty,
    /// Camera actors found so far in the look that's going on, and how far it's got.
    scan: std.ArrayList(Found) = .empty,
    scan_at: usize = 0,
    added: std.ArrayList(Added) = .empty,
    renamed: std.ArrayList(Renamed) = .empty,
    /// What Wraith was last told.
    listed: std.ArrayList(Listed) = .empty,
    told: bool = false,
    next_id: u64 = first_added,

    pub fn find(ue: *const Unreal, missing: *[]const u8) !Offsets {
        const names = [_][]const u8{ "PlayerController", "PlayerCameraManager", "CameraModifier" };
        var found: [names.len]usize = undefined;
        ue.findIn("/Script/Engine", &names, &found);
        for (names, found) |n, f| if (f == 0) {
            missing.* = n;
            return error.MissingClass;
        };
        const controller, const manager, const modifier = found;
        const add = ue.functionNamed(manager, "AddNewCameraModifier") orelse {
            missing.* = "AddNewCameraModifier";
            return error.MissingFunction;
        };
        const modify = ue.functionNamed(modifier, "BlueprintModifyCamera") orelse {
            missing.* = "BlueprintModifyCamera";
            return error.MissingFunction;
        };
        const off = struct {
            fn off(u: *const Unreal, class: usize, comptime name: []const u8, m: *[]const u8) !usize {
                return u.offsetOf(class, name) orelse {
                    m.* = name;
                    return error.MissingProperty;
                };
            }
        }.off;
        const remove = ue.functionNamed(manager, "RemoveCameraModifier");
        var views_missing: []const u8 = "";
        const views = Views.find(ue, &views_missing) catch blk: {
            log.info("Photo mode can't see through the level's cameras, since this Unreal's missing {s}", .{views_missing});
            break :blk null;
        };
        return .{
            .manager = try off(ue, controller, "PlayerCameraManager", missing),
            .modifier_class = modifier,
            .add = add,
            .add_size = @intCast(ue.structSize(add) orelse return error.MissingFunction),
            .add_class = try off(ue, add, "ModifierClass", missing),
            .add_returns = try off(ue, add, "ReturnValue", missing),
            .remove = remove,
            .remove_size = if (remove) |r| @intCast(ue.structSize(r) orelse 0) else 0,
            .remove_param = if (remove) |r| ue.offsetOf(r, "ModifierToRemove") orelse 0 else 0,
            .modify = modify,
            .in_location = try off(ue, modify, "ViewLocation", missing),
            .in_rotation = try off(ue, modify, "ViewRotation", missing),
            .in_fov = try off(ue, modify, "FOV", missing),
            .out_location = try off(ue, modify, "NewViewLocation", missing),
            .out_rotation = try off(ue, modify, "NewViewRotation", missing),
            .out_fov = try off(ue, modify, "NewFOV", missing),
            .views = views,
        };
    }

    pub fn start(self: *Camera, world: *const World, loop: *Loop, off: Offsets) void {
        self.world = world;
        self.loop = loop;
        self.off = off;
        const root = sdk.wraith.root() orelse return;
        self.tools = root.camera();
        const t = self.tools.?;
        t.setWorld(.{ .up = .pos_z, .look = .pos_x, .left_handed = true, .metre = metre });
        const list = t.cameras(W.ItemList.Add.init(self, onAdd), W.ItemList.Rename.init(self, onRename));
        // Wraith's too old for it
        if (list.table != null) self.list = list;
    }

    pub fn deinit(self: *Camera) void {
        self.level.deinit(gpa);
        self.scan.deinit(gpa);
        self.added.deinit(gpa);
        self.renamed.deinit(gpa);
        self.listed.deinit(gpa);
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

    /// Game thread, once a tick. Each new camera manager, like after a level load, gets ours, and the
    /// cameras are kept up to date for Photo mode.
    pub fn tick(self: *Camera) void {
        self.addModifier();
        const list = self.list orelse return;
        self.scanSome();
        self.dropGone();
        const asks = self.asks.take();
        if (asks.add) self.addCamera(list);
        if (asks.rename != 0) self.rename(asks.rename, asks.name.get());
        self.active = self.resolve(if (self.tools) |t| t.wantedCamera() else 0);
        self.tell(list) catch {};
    }

    fn addModifier(self: *Camera) void {
        const controller = self.world.playerController() orelse return;
        const manager = raw(usize, controller + self.off.manager);
        if (manager == 0) return;
        if (manager == self.manager) return;
        var params: [64]u8 align(16) = @splat(0);
        if (self.off.add_size > params.len) return;
        std.mem.writeInt(usize, params[self.off.add_class..][0..@sizeOf(usize)], self.off.modifier_class, .little);
        self.loop.call(manager, self.off.add, params[0..self.off.add_size]);
        const modifier = std.mem.readInt(usize, params[self.off.add_returns..][0..@sizeOf(usize)], .little);
        self.manager = manager;
        self.modifier = modifier;
        self.manager_slot = self.world.ue.objects.slotOf(manager);
        if (modifier != 0) self.modifier_slot = self.world.ue.objects.slotOf(modifier);
        if (modifier == 0) {
            log.warn("The camera manager wouldn't take a camera modifier, so the free camera can't move it", .{});
        } else if (!self.added_modifier) {
            log.info("The free camera moves the camera through a camera modifier of ours", .{});
            self.added_modifier = true;
        } else log.debug("A new camera manager, so it gets our camera modifier too", .{});
    }

    /// Looks through some more of the objects for camera actors, and once it's been through them
    /// all, they're the level's cameras.
    fn scanSome(self: *Camera) void {
        const views = self.off.views orelse return;
        const ue = self.world.ue;
        const count = ue.objects.countPlain();
        const end = @min(self.scan_at + scan_per_tick, count);
        for (self.scan_at..end) |i| {
            const obj = ue.objects.getPlain(i);
            if (ue.isLive(obj, views.actor)) self.scan.append(gpa, .{ .actor = obj, .slot = @intCast(i) }) catch {};
        }
        self.scan_at = end;
        if (end < count) return;
        self.scan_at = 0;
        self.level.clearRetainingCapacity();
        var buf: [256]u8 = undefined;
        for (self.scan.items) |f| {
            if (!self.alive(f.actor, f.slot)) continue;
            const name = ue.nameOfLive(f.actor, &buf) orelse "Camera";
            self.level.append(gpa, .{ .actor = f.actor, .slot = f.slot, .name = .init(name) }) catch {};
        }
        self.scan.clearRetainingCapacity();
    }

    /// Takes out camera actors destroyed since they were found.
    fn dropGone(self: *Camera) void {
        var i: usize = 0;
        while (i < self.level.items.len) {
            const l = self.level.items[i];
            if (self.alive(l.actor, l.slot)) i += 1 else _ = self.level.orderedRemove(i);
        }
    }

    /// Still a camera actor, so it's safe to look through. Game thread only. Its slot in the object
    /// array's checked first, so one that's been destroyed and freed is never read.
    fn alive(self: *const Camera, actor: usize, slot: u32) bool {
        const views = self.off.views orelse return false;
        const ue = self.world.ue;
        return ue.objects.isAt(actor, slot) and ue.isLive(actor, views.actor);
    }

    /// What Wraith says to show, from Follow selection: `want` if it's still around, or else the
    /// game's own.
    fn resolve(self: *const Camera, want: u64) u64 {
        if (want == 0 or want == game_id) return game_id;
        if (self.addedIndex(want) != null) return want;
        if (self.levelIndex(want) != null) return want;
        return game_id;
    }

    fn addedIndex(self: *const Camera, id: u64) ?usize {
        for (self.added.items, 0..) |a, i| if (a.id == id) return i;
        return null;
    }

    fn levelIndex(self: *const Camera, id: u64) ?usize {
        for (self.level.items, 0..) |l, i| if (l.actor == id) return i;
        return null;
    }

    /// A new camera where the view is, shown once the player picks it.
    fn addCamera(self: *Camera, list: W.ItemList) void {
        const pose = self.shown orelse return;
        const id = self.next_id;
        var buf: [32]u8 = undefined;
        const name = std.fmt.bufPrint(&buf, "Wraith camera {d}", .{id - first_added + 1}) catch "Wraith camera";
        self.added.append(gpa, .{ .id = id, .pose = pose, .name = .init(name) }) catch return;
        self.next_id += 1;
        self.tell(list) catch {};
        list.select(id);
    }

    /// Added ones take it, and the rest keep it here, since Unreal's names can't change.
    fn rename(self: *Camera, id: u64, name: []const u8) void {
        if (self.addedIndex(id)) |i| {
            self.added.items[i].name = .init(name);
            return;
        }
        for (self.renamed.items) |*r| if (r.id == id) {
            r.name = .init(name);
            return;
        };
        self.renamed.append(gpa, .{ .id = id, .name = .init(name) }) catch {};
    }

    fn nameFor(self: *const Camera, id: u64, own: Name) Name {
        for (self.renamed.items) |r| if (r.id == id) return r.name;
        return own;
    }

    /// The game's own, then the level's, then the added ones.
    fn listing(self: *const Camera, out: *std.ArrayList(Listed)) !void {
        try out.append(gpa, .{ .id = game_id, .current = self.active == game_id, .name = self.nameFor(game_id, .init("Game camera")), .detail = "What the game shows" });
        for (self.level.items) |l| {
            try out.append(gpa, .{ .id = l.actor, .current = self.active == l.actor, .name = self.nameFor(l.actor, l.name), .detail = "In the level" });
        }
        for (self.added.items) |a| {
            try out.append(gpa, .{ .id = a.id, .current = self.active == a.id, .name = a.name, .detail = "Added in Photo mode" });
        }
    }

    /// Tells Wraith the cameras, if they've changed since it was last told.
    fn tell(self: *Camera, list: W.ItemList) !void {
        var next: std.ArrayList(Listed) = .empty;
        errdefer next.deinit(gpa);
        try self.listing(&next);
        if (self.told and Listed.same(next.items, self.listed.items)) return next.deinit(gpa);
        self.listed.deinit(gpa);
        self.listed = next;
        self.told = true;
        var items: std.ArrayList(W.ItemList.Item) = .empty;
        defer items.deinit(gpa);
        for (self.listed.items) |*l| {
            try items.append(gpa, .{ .id = l.id, .name = l.name.get(), .detail = l.detail, .current = l.current });
        }
        list.set(items.items);
    }

    /// Game thread. Takes ours back out of the camera manager, so a reload doesn't pile them up.
    pub fn leave(self: *Camera) void {
        if (self.modifier == 0 or self.manager == 0) return;
        const remove = self.off.remove orelse return;
        defer self.modifier = 0;
        const objects = &self.world.ue.objects;
        if (!objects.isAt(self.manager, self.manager_slot) or !objects.isAt(self.modifier, self.modifier_slot)) return;
        var params: [32]u8 align(16) = @splat(0);
        if (self.off.remove_size > params.len) return;
        std.mem.writeInt(usize, params[self.off.remove_param..][0..@sizeOf(usize)], self.modifier, .little);
        self.loop.call(self.manager, remove, params[0..self.off.remove_size]);
    }

    /// Game thread, once a camera modifier's `BlueprintModifyCamera` has run.
    pub fn onModify(context: *anyopaque, modifier: usize, params: ?*anyopaque) void {
        const self: *Camera = @ptrCast(@alignCast(context));
        if (modifier != self.modifier or modifier == 0) return;
        const p = params orelse return;
        const io = Io.init(self.world.ue.layout.doubles);
        const view = self.viewOf(io);
        const shown = if (self.tools) |t| steerWith(t, io, self.off, @intFromPtr(p), view) else steerWith(NoTools{}, io, self.off, @intFromPtr(p), view);
        if (shown) |pose| {
            self.shown = pose;
            // An added one stays where the free camera left it
            if (self.addedIndex(view.id)) |i| self.added.items[i].pose = pose;
            publish(self.loop, pose);
        }
        if (self.late) |l| l.func(l.context);
    }

    /// The camera to show, and where it is, or null for the game's own.
    fn viewOf(self: *Camera, io: Io) View {
        if (self.active == game_id) return .{ .id = game_id };
        if (self.addedIndex(self.active)) |i| return .{ .id = self.active, .pose = self.added.items[i].pose };
        if (self.levelIndex(self.active)) |i| {
            const l = self.level.items[i];
            if (self.alive(l.actor, l.slot)) if (self.poseOf(io, l.actor)) |pose| return .{ .id = self.active, .pose = pose };
        }
        self.active = game_id;
        return .{ .id = game_id };
    }

    /// Where a camera actor's camera is. Game thread only, on one that's `alive`.
    fn poseOf(self: *Camera, io: Io, actor: usize) ?Pose {
        const views = self.off.views orelse return null;
        // A live actor's components are live, so it's all read plainly
        const component = raw(usize, actor + views.component);
        if (component == 0) return null;
        var params: [64]u8 align(16) = @splat(0);
        if (views.location.size > params.len or views.rotation.size > params.len) return null;
        self.loop.call(component, views.location.function, params[0..views.location.size]);
        const l = io.read3(@intFromPtr(&params) + views.location.params[0]) orelse return null;
        params = @splat(0);
        self.loop.call(component, views.rotation.function, params[0..views.rotation.size]);
        const r = io.read3(@intFromPtr(&params) + views.rotation.params[0]) orelse return null;
        const fov = raw(f32, component + views.fov);
        if (!(fov > 0 and fov < 180)) return null;
        return .{ .position = .{ .x = l[0], .y = l[1], .z = l[2] }, .rotation = quatOf(r), .fov = fov };
    }

    const NoTools = struct {
        fn camera(_: NoTools, _: u64, _: *W.FreeCamera.State) void {}
    };
};

/// The camera to show: its id, so the free camera carries on from a new one, and where it is, or
/// null for the game's own.
const View = struct { id: u64, pose: ?Pose = null };

/// `tools` is the free camera, or a stand-in. Gives back the camera as it'll be shown.
fn steerWith(tools: anytype, io: Io, off: Offsets, params: usize, view: View) ?Pose {
    const game = io.readPose(params + off.in_location, params + off.in_rotation, params + off.in_fov) orelse return null;
    const from = view.pose orelse game;
    var state: W.FreeCamera.State = .{
        .position = from.position,
        .aim = .rotation,
        .target = .{},
        .up = .{ .z = 1 },
        .rotation = from.rotation,
        .roll = 0,
        .fov = std.math.degreesToRadians(from.fov),
    };
    const before = state;
    tools.camera(view.id, &state);
    if (std.meta.eql(state, before)) {
        if (view.pose == null) return game;
        io.writePose(params + off.out_location, params + off.out_rotation, params + off.out_fov, from);
        return from;
    }
    const ours: Pose = .{ .position = state.position, .rotation = state.rotation, .fov = std.math.radiansToDegrees(state.fov) };
    io.writePose(params + off.out_location, params + off.out_rotation, params + off.out_fov, ours);
    return ours;
}

/// The view as Wraith wants it, D3D's way round, for drawing over the world.
fn publish(loop: *const Loop, pose: Pose) void {
    const v = viewOf(pose, loop.aspectRatio());
    sdk.display.setView(v.view, v.projection);
}

fn viewOf(pose: Pose, aspect: f32) struct { view: Mat4, projection: Mat4 } {
    const forward = pose.rotation.rotate(.{ .x = 1 });
    const up = pose.rotation.rotate(.{ .z = 1 });
    const h = std.math.degreesToRadians(std.math.clamp(pose.fov, 1, 170));
    const v = 2 * std.math.atan(@tan(h / 2) / aspect);
    return .{
        .view = .lookAt(pose.position, pose.position.add(forward), up, .left),
        .projection = .perspective(v, aspect, near, far, .left),
    };
}

/// A plain read, of what the game's using right now.
fn raw(comptime T: type, at: usize) T {
    return @as(*align(1) const T, @ptrFromInt(at)).*;
}

fn writeRaw(comptime T: type, at: usize, value: T) void {
    @as(*align(1) T, @ptrFromInt(at)).* = value;
}

/// Reads and writes Unreal's vectors and rotators, floats before UE5 and doubles after, plainly,
/// in what the game's just handed over.
const Io = struct {
    doubles: bool,

    fn init(doubles: bool) Io {
        return .{ .doubles = doubles };
    }

    fn read3(self: Io, at: usize) ?[3]f32 {
        if (self.doubles) {
            const v = raw([3]f64, at);
            return .{ @floatCast(v[0]), @floatCast(v[1]), @floatCast(v[2]) };
        }
        return raw([3]f32, at);
    }

    fn write3(self: Io, at: usize, v: [3]f32) void {
        if (self.doubles) {
            writeRaw([3]f64, at, .{ v[0], v[1], v[2] });
        } else writeRaw([3]f32, at, v);
    }

    fn readPose(self: Io, location: usize, rotation: usize, fov: usize) ?Pose {
        const l = self.read3(location) orelse return null;
        const r = self.read3(rotation) orelse return null;
        const f = raw(f32, fov);
        if (!(f > 0 and f < 180)) return null;
        return .{ .position = .{ .x = l[0], .y = l[1], .z = l[2] }, .rotation = quatOf(r), .fov = f };
    }

    fn writePose(self: Io, location: usize, rotation: usize, fov: usize, pose: Pose) void {
        self.write3(location, .{ pose.position.x, pose.position.y, pose.position.z });
        self.write3(rotation, rotatorOf(pose.rotation));
        writeRaw(f32, fov, pose.fov);
    }
};

/// `FRotator`'s pitch, yaw and roll in degrees to a quaternion, the way `FRotator::Quaternion` does.
pub fn quatOf(rotator: [3]f32) Quat {
    const half = std.math.pi / 360.0;
    const sp, const cp = .{ @sin(rotator[0] * half), @cos(rotator[0] * half) };
    const sy, const cy = .{ @sin(rotator[1] * half), @cos(rotator[1] * half) };
    const sr, const cr = .{ @sin(rotator[2] * half), @cos(rotator[2] * half) };
    return .{
        .x = cr * sp * sy - sr * cp * cy,
        .y = -cr * sp * cy - sr * cp * sy,
        .z = cr * cp * sy - sr * sp * cy,
        .w = cr * cp * cy + sr * sp * sy,
    };
}

/// Back to pitch, yaw and roll, the way `FQuat::Rotator` does.
pub fn rotatorOf(q: Quat) [3]f32 {
    const to_deg = 180.0 / std.math.pi;
    const singularity = q.z * q.x - q.w * q.y;
    const yaw = std.math.atan2(2 * (q.w * q.z + q.x * q.y), 1 - 2 * (q.y * q.y + q.z * q.z)) * to_deg;
    const threshold = 0.4999995;
    if (singularity < -threshold) return .{ -90, yaw, normalizeAxis(-yaw - 2 * std.math.atan2(q.x, q.w) * to_deg) };
    if (singularity > threshold) return .{ 90, yaw, normalizeAxis(yaw - 2 * std.math.atan2(q.x, q.w) * to_deg) };
    const pitch = std.math.asin(2 * singularity) * to_deg;
    const roll = std.math.atan2(-2 * (q.w * q.x + q.y * q.z), 1 - 2 * (q.x * q.x + q.y * q.y)) * to_deg;
    return .{ pitch, yaw, roll };
}

fn normalizeAxis(angle: f32) f32 {
    var a = @mod(angle, 360);
    if (a > 180) a -= 360;
    return a;
}

const testing = std.testing;

fn expectVec(want: Vec3, got: Vec3) !void {
    try testing.expectApproxEqAbs(want.x, got.x, 1e-4);
    try testing.expectApproxEqAbs(want.y, got.y, 1e-4);
    try testing.expectApproxEqAbs(want.z, got.z, 1e-4);
}

test "rotators turn the way Unreal's do" {
    // Yaw turns from +x, forward, toward +y, right
    try expectVec(.{ .y = 1 }, quatOf(.{ 0, 90, 0 }).rotate(.{ .x = 1 }));
    // Pitch looks up, toward +z
    try expectVec(.{ .x = @cos(std.math.pi / 6.0), .z = 0.5 }, quatOf(.{ 30, 0, 0 }).rotate(.{ .x = 1 }));
    // And back
    for ([_][3]f32{ .{ 20, -135, 10 }, .{ -45, 60, 0 }, .{ 0, 179, -30 } }) |r| {
        const back = rotatorOf(quatOf(r));
        for (r, back) |a, b| try testing.expectApproxEqAbs(a, b, 1e-3);
    }
}

test "the view looks where the camera does" {
    const pose: Pose = .{ .position = .{ .x = 100 }, .rotation = quatOf(.{ 0, 90, 0 }), .fov = 90 };
    const v = viewOf(pose, 16.0 / 9.0);
    // Ahead of it, which is +y now, is in front, and centred
    const ahead = v.view.transformPoint(.{ .x = 100, .y = 500 });
    try testing.expect(ahead.z > 0);
    try testing.expectApproxEqAbs(0, ahead.x, 1e-3);
    // Its right, +y turned, is -x in the world, and right on screen
    try testing.expect(v.view.transformPoint(.{ .x = 0, .y = 500 }).x > 0);
}

/// A params block laid out like `BlueprintModifyCamera`'s.
const Fake = extern struct {
    delta: f32 = 0.016,
    location: [3]f32 = .{ 1, 2, 3 },
    rotation: [3]f32 = .{ 0, 45, 0 },
    fov: f32 = 80,
    new_location: [3]f32 = .{ 1, 2, 3 },
    new_rotation: [3]f32 = .{ 0, 45, 0 },
    new_fov: f32 = 80,

    const off: Offsets = .{
        .manager = 0,
        .modifier_class = 0,
        .add = 0,
        .add_size = 0,
        .add_class = 0,
        .add_returns = 0,
        .modify = 1,
        .in_location = @offsetOf(Fake, "location"),
        .in_rotation = @offsetOf(Fake, "rotation"),
        .in_fov = @offsetOf(Fake, "fov"),
        .out_location = @offsetOf(Fake, "new_location"),
        .out_rotation = @offsetOf(Fake, "new_rotation"),
        .out_fov = @offsetOf(Fake, "new_fov"),
    };
};

const FakeTools = struct {
    on: bool = false,
    seen: Vec3 = .{},

    pub fn camera(self: *FakeTools, _: u64, state: *W.FreeCamera.State) void {
        self.seen = state.position;
        if (!self.on) return;
        state.position = .{ .x = 9 };
        state.fov = std.math.degreesToRadians(100);
    }
};

test "the camera's the free camera's while it has it, and left alone otherwise" {
    var tools: FakeTools = .{};
    var p: Fake = .{};
    const at = @intFromPtr(&p);
    const io = Io.init(false);

    // Off, the free camera sees the game's camera and nothing changes
    const off_pose = steerWith(&tools, io, Fake.off, at, .{ .id = game_id }).?;
    try testing.expectEqual(1, tools.seen.x);
    try testing.expectEqual(1, off_pose.position.x);
    try testing.expectEqual(1, p.new_location[0]);

    // On, the new camera is ours, with the game's rotation kept
    tools.on = true;
    _ = steerWith(&tools, io, Fake.off, at, .{ .id = game_id });
    try testing.expectEqual(9, p.new_location[0]);
    try testing.expectApproxEqAbs(100, p.new_fov, 1e-3);
    try testing.expectApproxEqAbs(45, p.new_rotation[1], 1e-3);
    // And it still sees the game's own each frame
    try testing.expectEqual(1, tools.seen.x);
}

test "a picked camera's shown, and the free camera carries on from it" {
    var tools: FakeTools = .{};
    var p: Fake = .{};
    const at = @intFromPtr(&p);
    const io = Io.init(false);
    const picked: Pose = .{ .position = .{ .x = 50 }, .rotation = quatOf(.{ 0, 90, 0 }), .fov = 60 };

    // Off, the picked one's shown as it is
    const shown = steerWith(&tools, io, Fake.off, at, .{ .id = 7, .pose = picked }).?;
    try testing.expectEqual(50, shown.position.x);
    try testing.expectEqual(50, p.new_location[0]);
    try testing.expectApproxEqAbs(60, p.new_fov, 1e-3);
    try testing.expectApproxEqAbs(90, p.new_rotation[1], 1e-3);
    // And the free camera starts from it, not the game's
    try testing.expectEqual(50, tools.seen.x);

    // On, it's the free camera's
    tools.on = true;
    _ = steerWith(&tools, io, Fake.off, at, .{ .id = 7, .pose = picked });
    try testing.expectEqual(9, p.new_location[0]);
}

test "the game's camera comes first, then the level's, then added ones, with names the player gave" {
    var cam: Camera = .{};
    defer cam.deinit();
    try cam.level.append(gpa, .{ .actor = 0x5000, .slot = 0, .name = .init("CineCameraActor_1") });
    try cam.added.append(gpa, .{ .id = first_added, .pose = .{ .position = .{}, .rotation = .identity, .fov = 90 }, .name = .init("Wraith camera 1") });
    cam.rename(0x5000, "Balcony");
    cam.rename(first_added, "Close up");
    cam.active = cam.resolve(first_added);

    var listed: std.ArrayList(Listed) = .empty;
    defer listed.deinit(gpa);
    try cam.listing(&listed);
    try testing.expectEqual(3, listed.items.len);
    try testing.expectEqual(game_id, listed.items[0].id);
    try testing.expectEqualStrings("Balcony", listed.items[1].name.get());
    try testing.expectEqualStrings("Close up", listed.items[2].name.get());
    try testing.expect(listed.items[2].current and !listed.items[0].current);

    // One that's gone, or none, is the game's own
    try testing.expectEqual(game_id, cam.resolve(0x9999));
    try testing.expectEqual(game_id, cam.resolve(0));
    try testing.expectEqual(0x5000, cam.resolve(0x5000));
}
