//! The game's camera, right after the camera manager sets it each frame. The free camera gets to move
//! it, Photo mode's Lens sets its near clip and shift, then it's Wraith's view of the game, for posing
//! and anything else drawing over the world.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const ui = sdk.ui;
const schema = @import("schema").TrailsHorizon;

const CameraManager = schema.CameraManager;
const Apply = CameraManager.Fns.applyCamera;
const ApplyHook = sdk.hooks.FnHook(Apply);
const Look = @import("look.zig").Look;

/// Photo mode's Lens. Zero for the game's own.
const Lens = struct {
    /// Metres
    near: f32 = 0,
    shift_x: f32 = 0,
    shift_y: f32 = 0,

    fn any(l: Lens) bool {
        return l.near > 0 or l.shift_x != 0 or l.shift_y != 0;
    }
};

/// The game's own, kept while Lens has its own on, to put back after.
const Gave = struct { camera: *schema.Camera, near: f32, shift_x: f32, shift_y: f32 };

pub const Camera = struct {
    tools: ?W.FreeCamera = null,
    apply: ApplyHook = undefined,
    lock: sdk.sync.RwLock = .{},
    /// Under `lock`: what the Lens section asks for
    lens: Lens = .{},
    lens_part: sdk.slots.PhotoPart = .{ .info = .{ .id = "lens", .kind = "camera", .title = "Lens", .presentation = .foldout, .open = true, .order = 300 } },
    lens_section: ?W.Contribution = null,
    // Game thread
    gave: ?Gave = null,
    /// Photo mode's Look, set each frame after the camera, so it can focus ahead of it
    look: ?*Look = null,

    pub fn start(self: *Camera) !void {
        self.tools = if (sdk.wraith.root()) |w| w.camera() else null;
        if (self.tools) |t| t.setWorld(.{ .up = .pos_y, .look = .neg_z, .left_handed = false, .metre = 1 });
        self.apply = try sdk.hooks.createFnWith(Apply, try CameraManager.addresses.applyCamera(), applyCamera, self, .{ .enabled = true });
        // An older Wraith has no slots, so there's just no Lens
        self.lens_section = sdk.slots.addPhotoPart("photo.inspector", &self.lens_part, self, drawLens) catch null;
    }

    /// Takes Lens out of Photo mode. The game's own come back next frame.
    pub fn stop(self: *Camera) void {
        if (self.lens_section) |c| c.remove();
        self.lens_section = null;
        self.lock.lock();
        defer self.lock.unlock();
        self.lens = .{};
    }

    fn applyCamera(self: *Camera, hook: ApplyHook, manager: *CameraManager, dt: f32, index: i32) void {
        hook.original()(manager, dt, index);
        const camera = manager.camera orelse return;
        if (self.tools) |t| steer(t, camera);
        self.applyLens(camera);
        if (self.look) |l| l.apply(camera);
        sdk.display.setView(camera.view, camera.proj);
    }

    /// Lens's near clip and shift, every frame while either's on, else the game's back once.
    fn applyLens(self: *Camera, camera: *schema.Camera) void {
        const want = blk: {
            self.lock.lockShared();
            defer self.lock.unlockShared();
            break :blk self.lens;
        };
        // Another camera, like after loading, has its own to keep
        if (self.gave) |g| if (g.camera != camera) {
            self.gave = null;
        };
        if (!want.any()) {
            const g = self.gave orelse return;
            camera.near = g.near;
            camera.shift_x = g.shift_x;
            camera.shift_y = g.shift_y;
            camera.updateMatrices();
            self.gave = null;
            return;
        }
        const g = self.gave orelse made: {
            self.gave = .{ .camera = camera, .near = camera.near, .shift_x = camera.shift_x, .shift_y = camera.shift_y };
            break :made self.gave.?;
        };
        camera.near = if (want.near > 0) want.near else g.near;
        camera.shift_x = g.shift_x + want.shift_x;
        camera.shift_y = g.shift_y + want.shift_y;
        camera.updateMatrices();
    }

    fn drawLens(self: *Camera, _: W.Slot.Target) void {
        self.lock.lock();
        defer self.lock.unlock();
        const l = &self.lens;
        ui.setNextItemWidth(200);
        _ = ui.sliderWith("Near clip", &l.near, 0, 1, .{ .format = if (l.near > 0) "%.3f m" else "Game's" });
        ui.tooltip("How close things can be before they're cut away. Lower for close-ups. 0 is the game's.", .{});
        ui.setNextItemWidth(200);
        _ = ui.sliderWith("Shift across", &l.shift_x, -1, 1, .{ .format = "%.2f" });
        ui.tooltip("Slides the picture sideways without turning the camera, like a tilt-shift lens. Right-click for none.", .{});
        if (ui.contextMenu("##shift_x")) |m| {
            defer m.end();
            if (ui.menuItem("None", .{})) l.shift_x = 0;
        }
        ui.setNextItemWidth(200);
        _ = ui.sliderWith("Shift up", &l.shift_y, -1, 1, .{ .format = "%.2f" });
        ui.tooltip("Slides the picture up or down without tilting, so upright lines stay upright. Right-click for none.", .{});
        if (ui.contextMenu("##shift_y")) |m| {
            defer m.end();
            if (ui.menuItem("None", .{})) l.shift_y = 0;
        }
        ui.textDisabled("For the game's camera.", .{});
    }

    fn steer(tools: W.FreeCamera, camera: *schema.Camera) void {
        var view: W.FreeCamera.State = .{
            .position = camera.eye,
            .aim = .target,
            .target = camera.target,
            .up = camera.up,
            .roll = camera.roll,
            .fov = camera.fov,
        };
        const before = view;
        tools.camera(0, &view);
        if (std.meta.eql(view, before)) return;
        camera.eye = view.position;
        camera.target = view.target;
        camera.up = view.up;
        camera.roll = view.roll;
        camera.fov = view.fov;
        camera.updateMatrices();
    }
};
