//! The game's camera, right after the camera manager sets it each frame. Camera Tools gets to move
//! it, and posing gets to see it.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");

const CameraManager = schema.CameraManager;
const Apply = CameraManager.Fns.applyCamera;
const ApplyHook = sdk.hooks.FnHook(Apply);

pub const Camera = struct {
    tools: ?schema.CameraTools = null,
    posing: ?schema.Posing = null,
    apply: ApplyHook = undefined,

    pub fn start(self: *Camera) !void {
        self.tools = sdk.salamander.service(schema.CameraTools, "camera");
        self.posing = sdk.salamander.service(schema.Posing, "posing");
        if (self.tools == null and self.posing == null) return error.NothingWantsTheCamera;
        if (self.tools) |t| t.world(.{ .up = .pos_y, .look = .neg_z, .left_handed = false, .metre = 1 });
        self.apply = try sdk.hooks.createFnWith(Apply, try CameraManager.addresses.applyCamera(), applyCamera, self, .{ .enabled = true });
    }

    fn applyCamera(self: *Camera, hook: ApplyHook, manager: *CameraManager, dt: f32, index: i32) void {
        hook.original()(manager, dt, index);
        const camera = manager.camera orelse return;
        if (self.tools) |t| steer(t, camera);
        if (self.posing) |p| p.camera(camera.view, camera.proj);
    }

    fn steer(tools: schema.CameraTools, camera: *schema.Camera) void {
        var view: schema.CamState = .{
            .position = camera.eye,
            .aim = .target,
            .target = camera.target,
            .up = camera.up,
            .roll = camera.roll,
            .fov = camera.fov,
        };
        const before = view;
        tools.camera(&view);
        if (std.meta.eql(view, before)) return;
        camera.eye = view.position;
        camera.target = view.target;
        camera.up = view.up;
        camera.roll = view.roll;
        camera.fov = view.fov;
        camera.updateMatrices();
    }
};
