//! Clean shot: hides the HUD and menus while it's on, by skipping the UI's layers in each frame's 2D
//! pass. What draws into textures, like portraits, still does.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const ui = sdk.ui;
const schema = @import("schema").TrailsHorizon;

const UiLayers = schema.UiLayers;
const DrawHook = sdk.hooks.FnHook(UiLayers.Fns.drawLayer);

const log = sdk.log.scoped(.trails_horizon);

/// The layers each frame's 2D pass draws the HUD and menus on, the 3D UI over people included.
/// Portraits and the like draw on others, into textures.
const screen_layers = [_]i32{ 0, 5, 10, 15, 19, 20, 21, 85, 90, 95, 96, 100 };

pub const Clean = struct {
    /// Any thread: the toolbar sets it, the game's drawing reads it
    on: std.atomic.Value(bool) = .init(false),
    draw: DrawHook = undefined,
    part: sdk.slots.PhotoPart = .{ .info = .{ .id = "clean_shot", .order = 450 } },
    button: ?W.Contribution = null,

    pub fn start(self: *Clean) !void {
        self.draw = try sdk.hooks.createFnWith(UiLayers.Fns.drawLayer, try UiLayers.addresses.drawLayer(), drawLayer, self, .{ .enabled = true });
        // An older Wraith has no slots, so there's just no button
        self.button = sdk.slots.addPhotoPart("photo.toolbar", &self.part, self, drawButton) catch |err| blk: {
            log.debug("No clean shot in Photo mode: {t}", .{err});
            break :blk null;
        };
    }

    /// Takes its button out of Photo mode, and shows the UI again.
    pub fn stop(self: *Clean) void {
        if (self.button) |b| b.remove();
        self.button = null;
        self.on.store(false, .release);
    }

    fn drawLayer(self: *Clean, hook: DrawHook, layers: *UiLayers, commands: usize, layer: i32) void {
        if (self.on.load(.acquire) and std.mem.indexOfScalar(i32, &screen_layers, layer) != null) return;
        hook.original()(layers, commands, layer);
    }

    fn drawButton(self: *Clean, _: W.Slot.Target) void {
        const on = self.on.load(.acquire);
        const lit: ui.StyleColors = if (on) ui.withStyleColor(.button, .button_active) else ui.withColor(.button, @as(u32, 0));
        defer lit.end();
        // Lucide's eye-off and eye, from Wraith's icon font
        if (ui.iconButton(if (on) "\u{e0bb}##clean_shot" else "\u{e0ba}##clean_shot", "")) self.on.store(!on, .release);
        ui.tooltip("{s} the game's HUD and menus, for a clean shot", .{if (on) "Show" else "Hide"});
    }
};
