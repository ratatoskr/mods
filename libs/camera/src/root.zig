//! Camera tools: fly the game's camera around, or orbit it round a point. Game plugins hand over
//! their camera each frame through the `CameraTools` service in schemas/camera.sal, and this does
//! the controls, keys and settings.

const std = @import("std");
const sdk = @import("wraith_sdk");
const schema = @import("schema");
const rig = @import("rig.zig");
const controls = @import("controls.zig");
const Controls = controls.Controls;

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const W = sdk.api.wraith;
const V3 = rig.V3;

/// What the game's thread and the render thread share. The game's thread only copies in and out.
const Shared = struct {
    lock: sdk.atomic.Value(u32) = .init(0),
    basis: rig.Basis = .default,
    metre: f32 = 1,
    /// The game's camera, as of the last frame the free camera was off
    game: rig.Camera = undefined,
    seen: bool = false,
    on: bool = false,
    pose: rig.Pose = undefined,
    /// A point another plugin wants to orbit, till the render thread picks it up
    focus_at: ?V3 = null,

    fn acquire(s: *Shared) void {
        while (s.lock.cmpxchgWeak(0, 1, .acquire, .monotonic) != null) std.atomic.spinLoopHint();
    }

    fn release(s: *Shared) void {
        s.lock.store(0, .release);
    }

    /// The service. `world` and `camera` are for game plugins, `focus` for any plugin.
    pub fn world(s: *Shared, w: schema.CamWorld) void {
        s.acquire();
        defer s.release();
        s.basis = .init(@fromBackingInt(@intCast(@backingInt(w.up))), @fromBackingInt(@intCast(@backingInt(w.look))), w.left_handed);
        s.metre = if (w.metre > 0) w.metre else 1;
    }

    pub fn camera(s: *Shared, cam: *schema.CamState) void {
        s.acquire();
        defer s.release();
        var c = fromSchema(cam.*);
        if (!s.on) {
            s.game = c;
            s.seen = true;
            return;
        }
        s.pose.toCamera(s.basis, &c);
        toSchema(c, cam);
    }

    pub fn focus(s: *Shared, point: sdk.math.Vec3) void {
        s.acquire();
        defer s.release();
        s.focus_at = point.vec();
    }
};

fn fromSchema(c: schema.CamState) rig.Camera {
    return .{
        .position = c.position,
        .aim = @fromBackingInt(@intCast(@backingInt(c.aim))),
        .target = c.target,
        .up = c.up,
        .rotation = c.rotation,
        .roll = c.roll,
        .fov = c.fov,
    };
}

fn toSchema(c: rig.Camera, out: *schema.CamState) void {
    out.position = c.position;
    out.target = c.target;
    out.up = c.up;
    out.rotation = c.rotation;
    out.roll = c.roll;
    out.fov = c.fov;
}

/// Read each frame while it's on.
const Options = struct {
    speed: f32,
    smoothing: f32,
    take_input: bool,
    sensitivity: f32,
    mouse_look: MouseLook,
    gamepad: bool,
    pad_sensitivity: f32,
};

/// How close and far orbiting goes, in metres.
const min_distance = 0.2;
const max_distance = 100;

const MouseLook = enum { right, middle, left, always };
const mouse_look_options = [_][]const u8{ "While the right button's held", "While the middle button's held", "While the left button's held", "Always" };

const Corner = enum { top_left, top_right, bottom_left, bottom_right };
const corner_options = [_][]const u8{ "Top left", "Top right", "Bottom left", "Bottom right" };

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    shared: Shared = .{},
    controls: Controls = .{},
    speed: W.Setting = undefined,
    smoothing: W.Setting = undefined,
    take_input: W.Setting = undefined,
    sensitivity: W.Setting = undefined,
    mouse_look: W.Setting = undefined,
    gamepad: W.Setting = undefined,
    pad_sensitivity: W.Setting = undefined,
    show_controls: W.Setting = undefined,
    corner: W.Setting = undefined,

    // Render thread only from here down

    on: bool = false,
    taken: bool = false,
    /// Where the pose is heading, which it eases toward
    goal: rig.Pose = undefined,
    velocity: V3 = @splat(0),
    /// From the mouse wheel, times the speed setting
    boost: f32 = 1,
    /// Orbiting round `pivot` from `distance` away, rather than flying. Both ease toward their goals
    orbiting: bool = false,
    pivot: V3 = @splat(0),
    pivot_goal: V3 = @splat(0),
    distance: f32 = 3,
    distance_goal: f32 = 3,
    /// Whether it's asked Wraith to hold the mouse
    holding: bool = false,
    last_ms: f64 = 0,

    pub const services = .{cameraTools};

    pub fn cameraTools(self: *Plugin) schema.CameraTools {
        return .init(&self.shared, sdk.salamander.rt.implement(schema.CameraTools, Shared));
    }

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        const settings = ctx.wraith.settings();
        self.speed = try settings.add(.{ .id = "speed", .name = "Speed", .section = "Flying", .help = "In metres a second. Faster and Slower change it while they're held, and so does the mouse wheel.", .kind = .number, .min = 0.1, .max = 100, .step = 0.1, .has_default = true, .default_value = .{ .number = 3 } }, null);
        self.smoothing = try settings.add(.{ .id = "smoothing", .name = "Smoothing", .section = "Flying", .help = "Seconds it takes to catch up with the controls. 0 is instant.", .kind = .number, .min = 0, .max = 2, .step = 0.05, .has_default = true, .default_value = .{ .number = 0.3 } }, null);
        self.take_input = try settings.add(.{ .id = "take_input", .name = "Keep the game from seeing the controls", .section = "Flying", .kind = .toggle, .has_default = true, .default_value = .{ .toggle = true } }, null);
        self.mouse_look = try settings.add(.{ .id = "mouse_look", .name = "Look with the mouse", .section = "Mouse", .kind = .choice, .options = &mouse_look_options }, null);
        self.sensitivity = try settings.add(.{ .id = "sensitivity", .name = "Mouse sensitivity", .section = "Mouse", .help = "Degrees a pixel.", .kind = .number, .min = 0.01, .max = 1, .step = 0.01, .has_default = true, .default_value = .{ .number = 0.15 } }, null);
        self.gamepad = try settings.add(.{ .id = "gamepad", .name = "Use a controller", .section = "Controller", .help = "The left stick moves, the right stick looks, and the triggers go down and up. Its buttons are with the keys, like RB for Faster.", .kind = .toggle }, null);
        self.pad_sensitivity = try settings.add(.{ .id = "pad_sensitivity", .name = "Stick sensitivity", .section = "Controller", .help = "Degrees a second with the right stick all the way over.", .kind = .number, .min = 10, .max = 360, .step = 5, .has_default = true, .default_value = .{ .number = 120 } }, null);
        self.show_controls = try settings.add(.{ .id = "show_controls", .name = "Show the controls while flying", .section = "Controls", .kind = .toggle, .has_default = true, .default_value = .{ .toggle = true } }, null);
        self.corner = try settings.add(.{ .id = "controls_corner", .name = "Where they show", .section = "Controls", .kind = .choice, .options = &corner_options }, null);
        try self.controls.bind(ctx.wraith.input(), self, pressed);
        _ = try ctx.onFrame(self, tick);
    }

    pub fn stop(self: *Plugin) void {
        self.shared.acquire();
        self.shared.on = false;
        self.shared.release();
        self.takeInput(false);
        self.holdMouse(false);
    }

    fn pressed(ctx: *anyopaque, which: controls.Press) void {
        const self: *Plugin = @ptrCast(@alignCast(ctx));
        switch (which) {
            .toggle => self.flip(),
            .orbit => if (self.on and !uiHasKeys()) self.setOrbiting(!self.orbiting, null),
            .level => if (self.on and !uiHasKeys()) {
                self.goal.roll = 0;
            },
            .controls => if (self.on and !uiHasKeys()) {
                const shown = if (self.show_controls.get()) |v| v.toggle else |_| true;
                self.show_controls.set(.{ .toggle = !shown }) catch {};
            },
        }
    }

    fn flip(self: *Plugin) void {
        if (self.on) self.turnOff() else self.turnOn();
    }

    fn turnOn(self: *Plugin) void {
        {
            self.shared.acquire();
            defer self.shared.release();
            if (!self.shared.seen) {
                self.toast(.warning, "No camera yet. Camera Tools needs a plugin for this game that hands it the camera.");
                return;
            }
            self.goal = .fromCamera(self.shared.basis, self.shared.game);
            self.shared.pose = self.goal;
            self.shared.on = true;
        }
        self.on = true;
        self.orbiting = false;
        self.velocity = @splat(0);
        self.last_ms = self.ctx.wraith.frame().now();
        self.takeInput(self.readOptions().take_input);
        self.toast(.info, "On");
    }

    fn turnOff(self: *Plugin) void {
        self.shared.acquire();
        self.shared.on = false;
        self.shared.release();
        self.on = false;
        self.takeInput(false);
        self.holdMouse(false);
        self.toast(.info, "Off");
    }

    /// Round `around`, or a point ahead of it, from where it is now.
    fn setOrbiting(self: *Plugin, on: bool, around: ?V3) void {
        self.orbiting = on;
        self.velocity = @splat(0);
        if (!on) return;
        self.shared.acquire();
        const basis = self.shared.basis;
        const metre = self.shared.metre;
        const pose = self.shared.pose;
        self.shared.release();
        const pivot = around orelse pose.ahead(basis, 3 * metre);
        const away = rig.length(pivot - pose.position);
        // Keeps the camera where it is, and only turns it to face the pivot
        const distance = std.math.clamp(away, min_distance * metre, max_distance * metre);
        if (away > 1e-4) {
            const toward = (pivot - pose.position) / rig.splat(away);
            const facing: rig.Camera = .{ .position = .from(pose.position), .aim = .target, .target = .from(pose.position + toward), .rotation = .identity, .roll = pose.roll, .fov = pose.fov };
            const turned: rig.Pose = .fromCamera(basis, facing);
            self.goal.yaw = pose.yaw + std.math.wrap(turned.yaw - pose.yaw, std.math.pi);
            self.goal.pitch = turned.pitch;
        }
        self.pivot = if (around == null) pivot else pose.ahead(basis, distance);
        self.pivot_goal = pivot;
        self.distance = distance;
        self.distance_goal = distance;
        self.toast(.info, "Orbiting");
    }

    fn holdMouse(self: *Plugin, hold: bool) void {
        if (self.holding == hold) return;
        self.ctx.wraith.ui().holdMouse(hold);
        self.holding = hold;
    }

    fn takeInput(self: *Plugin, take: bool) void {
        if (self.taken == take) return;
        const ui = self.ctx.wraith.ui();
        ui.takeInput(.keyboard, take);
        ui.takeInput(.mouse, take);
        ui.takeInput(.gamepad, take);
        self.taken = take;
    }

    fn toast(self: *Plugin, kind: W.ToastKind, text: []const u8) void {
        _ = self.ctx.wraith.ui().toast(.{ .kind = kind, .title = "Camera", .text = text, .seconds = if (kind == .info) 1.5 else 5 });
    }

    fn readOptions(self: *Plugin) Options {
        return .{
            .speed = number(self.speed, 3),
            .smoothing = number(self.smoothing, 0.3),
            .take_input = toggle(self.take_input, true),
            .sensitivity = number(self.sensitivity, 0.15),
            .mouse_look = choice(MouseLook, self.mouse_look, &mouse_look_options),
            .gamepad = toggle(self.gamepad, false),
            .pad_sensitivity = number(self.pad_sensitivity, 120),
        };
    }

    /// Moves the camera from the controls, on the render thread.
    fn tick(self: *Plugin) void {
        self.shared.acquire();
        const focus_at = self.shared.focus_at;
        self.shared.focus_at = null;
        self.shared.release();
        if (focus_at) |point| {
            if (!self.on) self.turnOn();
            if (self.on) self.setOrbiting(true, point);
        }
        if (!self.on) return;
        const now = self.ctx.wraith.frame().now();
        // A long hitch shouldn't fling it
        const dt: f32 = @floatCast(@min((now - self.last_ms) / 1000, 0.1));
        self.last_ms = now;
        const options = self.readOptions();
        self.takeInput(options.take_input);

        self.shared.acquire();
        const basis = self.shared.basis;
        const metre = self.shared.metre;
        var pose = self.shared.pose;
        self.shared.release();

        const input = self.ctx.wraith.input();
        const typing = uiHasKeys();
        const pad: ?W.GamepadAxes = if (options.gamepad) input.gamepad() else null;
        const c = &self.controls;
        self.look(input, options, pad, dt, typing);

        // Moving, relative to where it faces, with Up and Down straight along the world's up
        var want: V3 = @splat(0);
        if (!typing) {
            var ahead = c.down(.forward) - c.down(.back);
            var across = c.down(.right) - c.down(.left);
            var rise = c.down(.up) - c.down(.down);
            if (pad) |p| {
                const stick = deadZone(p.left_x, p.left_y);
                ahead += stick.y;
                across += stick.x;
                rise += p.right_trigger - p.left_trigger;
            }
            const faster = c.isDown(.faster);
            const slower = c.isDown(.slower);
            const sides = self.goal.sides(basis);
            want = rig.splat(ahead) * self.goal.forward(basis) + rig.splat(across) * sides.right + rig.splat(rise) * basis.up;
            const len = rig.length(want);
            if (len > 1) want /= rig.splat(len);
            var speed = options.speed * self.boost * metre;
            if (faster) speed *= 4;
            if (slower) speed *= 0.25;
            want *= rig.splat(speed);
        }
        self.velocity = rig.ease(self.velocity, want, options.smoothing, dt);
        // Moving takes the pivot along while orbiting
        if (self.orbiting) self.pivot_goal += self.velocity * rig.splat(dt) else self.goal.position += self.velocity * rig.splat(dt);

        pose.yaw = rig.ease(pose.yaw, self.goal.yaw, options.smoothing, dt);
        pose.pitch = rig.ease(pose.pitch, self.goal.pitch, options.smoothing, dt);
        pose.roll = rig.ease(pose.roll, self.goal.roll, options.smoothing, dt);
        pose.fov = rig.ease(pose.fov, self.goal.fov, options.smoothing, dt);
        if (self.orbiting) {
            self.pivot = rig.ease(self.pivot, self.pivot_goal, options.smoothing, dt);
            self.distance = rig.ease(self.distance, self.distance_goal, options.smoothing, dt);
            pose.position = pose.orbiting(basis, self.pivot, self.distance);
            // So flying picks up from here
            self.goal.position = pose.position;
        } else pose.position = self.goal.position;

        self.shared.acquire();
        self.shared.pose = pose;
        self.shared.release();

        if (toggle(self.show_controls, true)) self.drawControls(options, pad != null);
    }

    /// Turning, rolling, zooming and the wheel's speed, into `goal`.
    fn look(self: *Plugin, input: W.Input, options: Options, pad: ?W.GamepadAxes, dt: f32, typing: bool) void {
        const c = &self.controls;
        // Held still while looking, so it never runs into the edge of the screen. Not when it's for
        // a window, but once it's looking, going over one doesn't stop it
        const button = switch (options.mouse_look) {
            .right => input.buttonDown(.right),
            .middle => input.buttonDown(.middle),
            .left => input.buttonDown(.left),
            .always => true,
        };
        const looking = button and (self.holding or !uiHasMouse());
        self.holdMouse(looking);
        if (looking) {
            const pushed = self.ctx.wraith.ui().mouseMotion();
            const k = std.math.degreesToRadians(options.sensitivity);
            self.goal.yaw += @as(f32, @floatFromInt(pushed.x)) * k;
            self.goal.pitch -= @as(f32, @floatFromInt(pushed.y)) * k;
        }

        var turn_x: f32 = 0;
        var turn_y: f32 = 0;
        var roll: f32 = 0;
        var zoom: f32 = 0;
        if (!typing) {
            turn_x = c.down(.turn_right) - c.down(.turn_left);
            turn_y = c.down(.turn_up) - c.down(.turn_down);
            roll = c.down(.roll_right) - c.down(.roll_left);
            zoom = c.down(.zoom_out) - c.down(.zoom_in);
        }
        const keys_rate = std.math.degreesToRadians(90) * dt;
        self.goal.yaw += turn_x * keys_rate;
        self.goal.pitch += turn_y * keys_rate;
        if (pad) |p| {
            const stick = deadZone(p.right_x, p.right_y);
            const pad_rate = std.math.degreesToRadians(options.pad_sensitivity) * dt;
            self.goal.yaw += stick.x * pad_rate;
            self.goal.pitch += stick.y * pad_rate;
        }
        self.goal.roll += std.math.clamp(roll, -1, 1) * std.math.degreesToRadians(45) * dt;
        if (self.goal.fov > 0) {
            const change = std.math.clamp(zoom, -1, 1) * std.math.degreesToRadians(20) * dt;
            self.goal.fov = std.math.clamp(self.goal.fov + change, std.math.degreesToRadians(5), std.math.degreesToRadians(150));
        }
        self.goal.pitch = std.math.clamp(self.goal.pitch, -rig.Pose.max_pitch, rig.Pose.max_pitch);

        if (sdk.overlay.available() and !uiHasMouse()) {
            const wheel = sdk.ui.getIO().MouseWheel;
            if (wheel != 0) {
                const step = std.math.pow(f32, 1.25, wheel);
                if (self.orbiting) {
                    const metre = self.shared.metre;
                    self.distance_goal = std.math.clamp(self.distance_goal / step, min_distance * metre, max_distance * metre);
                } else self.boost = std.math.clamp(self.boost * step, 0.05, 50);
            }
        }
    }

    /// What does what, in a corner, as the player has the keys.
    fn drawControls(self: *Plugin, options: Options, pad: bool) void {
        if (!sdk.overlay.available()) return;
        const ui = sdk.ui;
        const vp = ui.mainViewport();
        const margin = ui.scaled(12);
        const corner = choice(Corner, self.corner, &corner_options);
        const right = corner == .top_right or corner == .bottom_right;
        const bottom = corner == .bottom_left or corner == .bottom_right;
        ui.setNextWindowPos(.{
            if (right) vp.work_pos[0] + vp.work_size[0] - margin else vp.work_pos[0] + margin,
            if (bottom) vp.work_pos[1] + vp.work_size[1] - margin else vp.work_pos[1] + margin,
        }, .always, .{ if (right) 1 else 0, if (bottom) 1 else 0 });
        ui.setNextWindowBgAlpha(0.6);
        const window = ui.window("Camera controls", .{ .flags = .{
            .no_title_bar = true,
            .no_resize = true,
            .no_move = true,
            .no_collapse = true,
            .always_auto_resize = true,
            .no_saved_settings = true,
            .no_inputs = true,
            .no_focus_on_appearing = true,
            .no_nav = true,
            .no_docking = true,
        } }) orelse return;
        defer window.end();
        ui.textDisabled("{s}", .{if (self.orbiting) "Orbiting" else "Flying"});
        const table = ui.table("keys", 2, .{ .sizing = .fixed_fit }) orelse return;
        defer table.end();
        const c = &self.controls;
        var buf: [160]u8 = undefined;
        for ([_]controls.Hold{ .forward, .back, .left, .right, .up, .down, .faster, .slower }) |h| self.row(nameOf(h), "{s}", .{c.keyNames(&buf, h)});
        self.row("Look", "{s}", .{switch (options.mouse_look) {
            .right => "Hold the right mouse button",
            .middle => "Hold the middle mouse button",
            .left => "Hold the left mouse button",
            .always => "The mouse",
        }});
        for ([_]controls.Hold{ .turn_left, .turn_right, .turn_up, .turn_down, .roll_left, .roll_right }) |h| self.row(nameOf(h), "{s}", .{c.keyNames(&buf, h)});
        self.row("Level", "{s}", .{c.keyNames(&buf, controls.Press.level)});
        self.row("Zoom in", "{s}", .{c.keyNames(&buf, controls.Hold.zoom_in)});
        self.row("Zoom out", "{s}", .{c.keyNames(&buf, controls.Hold.zoom_out)});
        if (self.orbiting) self.row("Closer and further", "Mouse wheel", .{}) else self.row("Speed", "Mouse wheel", .{});
        self.row(if (self.orbiting) "Fly instead" else "Orbit instead", "{s}", .{c.keyNames(&buf, controls.Press.orbit)});
        if (pad) self.row("Controller", "Sticks move and look, triggers go down and up", .{});
        self.row("Hide these", "{s}", .{c.keyNames(&buf, controls.Press.controls)});
        self.row("Stop", "{s}", .{c.keyNames(&buf, controls.Press.toggle)});
    }

    fn nameOf(h: controls.Hold) []const u8 {
        return switch (h) {
            .forward => "Forward",
            .back => "Back",
            .left => "Left",
            .right => "Right",
            .up => "Up",
            .down => "Down",
            .faster => "Faster",
            .slower => "Slower",
            .turn_left => "Turn left",
            .turn_right => "Turn right",
            .turn_up => "Look up",
            .turn_down => "Look down",
            .roll_left => "Roll left",
            .roll_right => "Roll right",
            .zoom_in => "Zoom in",
            .zoom_out => "Zoom out",
        };
    }

    fn row(_: *Plugin, label: []const u8, comptime fmt: []const u8, args: anytype) void {
        const ui = sdk.ui;
        ui.tableNextRow();
        _ = ui.tableNextColumn();
        ui.textDisabled("{s}", .{label});
        _ = ui.tableNextColumn();
        ui.text(fmt, args);
    }
};

/// A window of Wraith's or a plugin's has the keyboard, like Posing's once it's clicked, so the keys
/// are for it. Clicking in the game gives them back.
fn uiHasKeys() bool {
    if (!sdk.overlay.available()) return false;
    return sdk.ui.getIO().WantTextInput or sdk.ui.isAnyWindowFocused();
}

/// The mouse is over a window, or dragging something in one.
fn uiHasMouse() bool {
    return sdk.overlay.available() and sdk.ui.getIO().WantCaptureMouse;
}

/// Nothing near the middle, then all of the stick's travel past that.
fn deadZone(x: f32, y: f32) sdk.math.Vec2 {
    const zone = 0.2;
    const stick: sdk.math.Vec2 = .init(x, y);
    const len = stick.length();
    if (len < zone) return .zero;
    return stick.scale(@min((len - zone) / (1 - zone), 1) / len);
}

fn number(s: W.Setting, fallback: f32) f32 {
    const v = s.get() catch return fallback;
    return @floatCast(v.number);
}

fn toggle(s: W.Setting, fallback: bool) bool {
    const v = s.get() catch return fallback;
    return v.toggle;
}

/// Which of `options` it's on, as `E`'s values in the same order.
fn choice(comptime E: type, s: W.Setting, options: []const []const u8) E {
    const v = s.get() catch return @fromBackingInt(0);
    for (options, 0..) |o, i| if (std.mem.eql(u8, o, v.text)) return @fromBackingInt(@intCast(i));
    return @fromBackingInt(0);
}

comptime {
    sdk.exportPlugin(Plugin);
}
