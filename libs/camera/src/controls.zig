//! Every key the camera has, bound through Wraith so players can pick their own in Settings, as many
//! as they like for each, like a key and a controller button. Held ones fire whatever modifiers
//! are down, so Shift can go faster while moving.

const std = @import("std");
const sdk = @import("wraith_sdk");

const W = sdk.api.wraith;

/// Kept down to move, look and so on.
pub const Hold = enum {
    forward,
    back,
    left,
    right,
    up,
    down,
    faster,
    slower,
    turn_left,
    turn_right,
    turn_up,
    turn_down,
    roll_left,
    roll_right,
    zoom_in,
    zoom_out,

    fn def(h: Hold) Def {
        return switch (h) {
            .forward => .{ "Forward", .w, &.{} },
            .back => .{ "Back", .s, &.{} },
            .left => .{ "Left", .a, &.{} },
            .right => .{ "Right", .d, &.{} },
            .up => .{ "Up", .e, &.{} },
            .down => .{ "Down", .q, &.{} },
            .faster => .{ "Faster", .left_shift, &.{.gamepad_right_shoulder} },
            .slower => .{ "Slower", .left_ctrl, &.{.gamepad_left_shoulder} },
            .turn_left => .{ "Turn left", .left, &.{} },
            .turn_right => .{ "Turn right", .right, &.{} },
            .turn_up => .{ "Look up", .up, &.{} },
            .turn_down => .{ "Look down", .down, &.{} },
            .roll_left => .{ "Roll left", .z, &.{.gamepad_dpad_left} },
            .roll_right => .{ "Roll right", .c, &.{.gamepad_dpad_right} },
            .zoom_in => .{ "Zoom in", .equal, &.{.gamepad_dpad_up} },
            .zoom_out => .{ "Zoom out", .minus, &.{.gamepad_dpad_down} },
        };
    }
};

/// Pressed once.
pub const Press = enum {
    toggle,
    orbit,
    level,
    controls,

    fn def(p: Press) Def {
        return switch (p) {
            // No controller button by default, so one that does something in the game doesn't
            // start it too. Players can add one
            .toggle => .{ "Turn the free camera on or off", .f6, &.{} },
            .orbit => .{ "Switch between flying and orbiting", .o, &.{.gamepad_x} },
            .level => .{ "Level the camera", .x, &.{.gamepad_y} },
            .controls => .{ "Show or hide the controls", .h, &.{} },
        };
    }
};

/// Its name, its first key, and any more by default.
const Def = struct { []const u8, W.Key, []const W.Key };

const Held = struct {
    keybind: ?W.Keybind = null,
    down: bool = false,

    fn fired(self: *Held, phase: W.KeyPhase) void {
        self.down = phase == .pressed;
    }
};

const Pressed = struct {
    keybind: ?W.Keybind = null,
    which: Press,
    owner: *Controls = undefined,

    fn fired(self: *Pressed, phase: W.KeyPhase) void {
        if (phase == .pressed) self.owner.on_press(self.owner.ctx, self.which);
    }
};

/// Has to stay put once bound.
pub const Controls = struct {
    holds: std.EnumArray(Hold, Held) = .initFill(.{}),
    presses: std.EnumArray(Press, Pressed) = .init(.{
        .toggle = .{ .which = .toggle },
        .orbit = .{ .which = .orbit },
        .level = .{ .which = .level },
        .controls = .{ .which = .controls },
    }),
    ctx: *anyopaque = undefined,
    on_press: *const fn (ctx: *anyopaque, which: Press) void = undefined,

    /// `on_press(ctx, which)` runs on the render thread when a `Press` key goes down.
    pub fn bind(self: *Controls, input: W.Input, ctx: *anyopaque, on_press: *const fn (*anyopaque, Press) void) !void {
        self.ctx = ctx;
        self.on_press = on_press;
        for (std.enums.values(Hold)) |h| {
            const name, const key, const also = h.def();
            var more: [3]W.Chord = undefined;
            const slot = self.holds.getPtr(h);
            // The game still sees them while the camera's off. Taking the input hides them while it's on
            slot.keybind = try input.bind(.{ .id = @tagName(h), .name = name, .chord = .{ .key = key, .mods = .{} }, .also = chords(&more, also), .passthrough = true, .while_typing = false, .scope = .global, .held = true }, W.KeybindFired.init(slot, Held.fired));
        }
        for (std.enums.values(Press)) |p| {
            const name, const key, const also = p.def();
            var more: [3]W.Chord = undefined;
            const slot = self.presses.getPtr(p);
            slot.owner = self;
            slot.keybind = try input.bind(.{ .id = @tagName(p), .name = name, .chord = .{ .key = key, .mods = .{} }, .also = chords(&more, also), .passthrough = p != .toggle, .while_typing = false, .scope = .global, .held = false }, W.KeybindFired.init(slot, Pressed.fired));
        }
    }

    fn chords(buf: *[3]W.Chord, keys: []const W.Key) []const W.Chord {
        for (keys, buf[0..keys.len]) |k, *c| c.* = .{ .key = k, .mods = .{} };
        return buf[0..keys.len];
    }

    /// 1 while it's down, else 0, for adding up into a direction.
    pub fn down(self: *const Controls, h: Hold) f32 {
        return if (self.holds.getPtrConst(h).down) 1 else 0;
    }

    pub fn isDown(self: *const Controls, h: Hold) bool {
        return self.holds.getPtrConst(h).down;
    }

    /// Its keys' names as the player has them, like `Left Shift / RB`, or `none`.
    pub fn keyNames(self: *const Controls, buf: []u8, which: anytype) []const u8 {
        const slot = switch (@TypeOf(which)) {
            Hold => self.holds.getPtrConst(which),
            Press => self.presses.getPtrConst(which),
            else => @compileError("a Hold or a Press"),
        };
        const kb = slot.keybind orelse return "none";
        const all = kb.chords();
        if (all.len == 0) return "none";
        var w: std.Io.Writer = .fixed(buf);
        for (all, 0..) |c, i| {
            const chord: sdk.keybinds.Chord = .{
                .key = @fromBackingInt(@backingInt(c.key)),
                .mods = .{ .ctrl = c.mods.ctrl, .shift = c.mods.shift, .alt = c.mods.alt, .super = c.mods.super },
            };
            var name_buf: [48]u8 = undefined;
            w.print("{s}{s}", .{ if (i > 0) " / " else "", sdk.ui.chordName(&name_buf, chord) }) catch break;
        }
        return w.buffered();
    }
};
