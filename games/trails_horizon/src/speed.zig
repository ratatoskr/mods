//! Game speed through the game's own time scale, the one High Speed Mode uses, so Wraith's speed
//! goes on top of it. The world's time changes, while play time, the frame rate, the menus and HUD
//! and the game's camera carry on at their own pace, so a paused world can still be looked around.

const sdk = @import("wraith_sdk");
const schema = @import("schema");

const HighSpeed = schema.HighSpeed;
const Application = schema.Application;
const UiManager = schema.UiManager;
const CameraManager = schema.CameraManager;
const ScaleHook = sdk.hooks.FnHook(HighSpeed.Fns.scale);
const UnscaledHook = sdk.hooks.FnHook(Application.Fns.unscaled);
const InGameHook = sdk.hooks.FnHook(Application.Fns.updateInGame);
const UiHook = sdk.hooks.FnHook(UiManager.Fns.update);
const CameraHook = sdk.hooks.FnHook(CameraManager.Fns.update);

/// A pause, as far as the world's concerned, a minute of it moving the world on by 6 milliseconds.
/// Not 0, so the menus and camera can have their time back by dividing by it.
const paused = 0.0001;

pub const Speed = struct {
    /// Ours, as f32 bits, from Wraith on any thread.
    ours: sdk.atomic.Value(u32) = .init(@bitCast(@as(f32, 1))),
    scale: ScaleHook = undefined,
    unscaled: UnscaledHook = undefined,
    in_game: InGameHook = undefined,
    ui: UiHook = undefined,
    camera: CameraHook = undefined,
    /// In the game's update while playing, the only one ours scales. Game thread only.
    updating: bool = false,

    pub fn start(self: *Speed, game: sdk.api.wraith.Game) !void {
        self.scale = try sdk.hooks.createFnWith(HighSpeed.Fns.scale, try HighSpeed.addresses.scale(), scaleDetour, self, .{ .enabled = true });
        self.unscaled = try sdk.hooks.createFnWith(Application.Fns.unscaled, try Application.addresses.unscaled(), unscaledDetour, self, .{ .enabled = true });
        self.in_game = try sdk.hooks.createFnWith(Application.Fns.updateInGame, try Application.addresses.updateInGame(), inGameDetour, self, .{ .enabled = true });
        self.ui = try sdk.hooks.createFnWith(UiManager.Fns.update, try UiManager.addresses.update(), uiDetour, self, .{ .enabled = true });
        self.camera = try sdk.hooks.createFnWith(CameraManager.Fns.update, try CameraManager.addresses.update(), cameraDetour, self, .{ .enabled = true });
        game.provideSpeed(.init(self, changed));
    }

    fn changed(self: *Speed, speed: f64) bool {
        self.ours.store(@bitCast(@as(f32, @floatCast(speed))), .release);
        return true;
    }

    fn factor(self: *const Speed) f32 {
        const ours: f32 = @bitCast(self.ours.load(.acquire));
        return @max(ours, paused);
    }

    fn inGameDetour(self: *Speed, hook: InGameHook, app: *Application, dt: f32) void {
        self.updating = true;
        defer self.updating = false;
        hook.original()(app, dt);
    }

    fn scaleDetour(self: *Speed, hook: ScaleHook, high_speed: *HighSpeed) f32 {
        const own = hook.original()(high_speed);
        return if (self.updating) own * self.factor() else own;
    }

    /// The game takes its own scale back out here, which ours isn't part of.
    fn unscaledDetour(self: *Speed, _: UnscaledHook, app: *Application, t: f32) f32 {
        const high_speed = app.high_speed orelse return t;
        const own = self.scale.original()(high_speed);
        return if (own > 0) t / own else t;
    }

    fn uiDetour(self: *Speed, hook: UiHook, ui: *UiManager, dt: f32) void {
        hook.original()(ui, self.ownPace(dt));
    }

    fn cameraDetour(self: *Speed, hook: CameraHook, camera: *CameraManager, dt: f32) void {
        hook.original()(camera, self.ownPace(dt));
    }

    /// `dt` without ours, for what keeps going while the world's slowed or paused.
    fn ownPace(self: *const Speed, dt: f32) f32 {
        return if (self.updating) dt / self.factor() else dt;
    }
};
