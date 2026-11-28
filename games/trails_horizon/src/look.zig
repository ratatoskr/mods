//! Photo mode's Look: the game's own screen effects, held where Photo mode sets them: depth of
//! field, black and white, negative and blur. The game's own come back when they're off.

const std = @import("std");
const sdk = @import("wraith_sdk");
const W = sdk.api.wraith;
const ui = sdk.ui;
const schema = @import("schema").TrailsHorizon;

const Ease = schema.Ease;
const DepthOfField = schema.DepthOfField;

const Want = struct {
    depth_of_field: bool = false,
    /// On what the camera looks at, else `focus_distance` ahead
    focus_on_target: bool = true,
    /// Metres
    focus_distance: f32 = 5,
    sharp_range: f32 = 2,
    blur_over: f32 = 10,
    blur: f32 = 3,
    monotone: f32 = 0,
    negative: f32 = 0,
    bokeh: f32 = 0,
};

/// The game's own, kept while Look has its own on, to put back after.
const GameDof = struct { dof: *DepthOfField, on: u8, focus_mode: i32, blur: Ease, sharp: Ease, falloff: Ease, target: usize, target_node: usize };
const GameEase = struct { at: *Ease, ease: Ease };

pub const Look = struct {
    lock: sdk.sync.RwLock = .{},
    /// Under `lock`
    want: Want = .{},
    part: sdk.slots.PhotoPart = .{ .info = .{ .id = "look", .kind = "camera", .title = "Look", .presentation = .foldout, .open = true, .order = 400 } },
    section: ?W.Contribution = null,
    // Game thread
    game_dof: ?GameDof = null,
    game_monotone: ?GameEase = null,
    game_negative: ?GameEase = null,
    game_bokeh: ?GameEase = null,

    pub fn start(self: *Look) void {
        // Takes the place of Wraith's own, which says there's none. An older Wraith has no slots
        self.section = sdk.slots.addPhotoPart("photo.inspector", &self.part, self, draw) catch null;
    }

    /// Takes Look out of Photo mode. The game's own come back next frame.
    pub fn stop(self: *Look) void {
        if (self.section) |c| c.remove();
        self.section = null;
        self.lock.lock();
        defer self.lock.unlock();
        self.want = .{};
    }

    /// Each frame after the camera's set, on the game's thread.
    pub fn apply(self: *Look, camera: *schema.Camera) void {
        const want = blk: {
            self.lock.lockShared();
            defer self.lock.unlockShared();
            break :blk self.want;
        };
        const graphics = (schema.Graphics.instance() catch null) orelse return;
        const renderer = graphics.renderer orelse return;
        if (renderer.depth_of_field) |dof| self.applyDof(dof, camera, want);
        if (renderer.monotone) |m| holdOrGive(&self.game_monotone, &m.amount, want.monotone);
        if (renderer.negative) |n| holdOrGive(&self.game_negative, &n.amount, want.negative);
        if (renderer.bokeh) |b| holdOrGive(&self.game_bokeh, &b.amount, want.bokeh);
    }

    fn applyDof(self: *Look, dof: *DepthOfField, camera: *schema.Camera, want: Want) void {
        // Another one, like after loading, has its own to keep
        if (self.game_dof) |g| if (g.dof != dof) {
            self.game_dof = null;
        };
        if (!want.depth_of_field) {
            const g = self.game_dof orelse return;
            dof.on = g.on;
            dof.focus_mode = g.focus_mode;
            dof.blur = g.blur;
            dof.sharp = g.sharp;
            dof.falloff = g.falloff;
            dof.target = g.target;
            dof.target_node = g.target_node;
            self.game_dof = null;
            return;
        }
        if (self.game_dof == null) self.game_dof = .{ .dof = dof, .on = dof.on, .focus_mode = dof.focus_mode, .blur = dof.blur, .sharp = dof.sharp, .falloff = dof.falloff, .target = dof.target, .target_node = dof.target_node };
        dof.on = 1;
        dof.target = 0;
        dof.target_node = 0;
        if (want.focus_on_target) dof.focus_mode = 0 else {
            dof.focus_mode = 2;
            const ahead = camera.target.sub(camera.eye).normalize();
            const point = camera.eye.add(ahead.scale(want.focus_distance));
            dof.focus_from = point;
            dof.focus_to = point;
            dof.focus = point;
            dof.focus_time = 0;
            dof.focus_elapsed = 0;
        }
        const half = want.sharp_range / 2;
        hold(&dof.blur, want.blur);
        hold(&dof.sharp, half);
        hold(&dof.falloff, half + @max(want.blur_over, 0.01));
    }

    fn draw(self: *Look, _: W.Slot.Target) void {
        self.lock.lock();
        defer self.lock.unlock();
        const w = &self.want;
        ui.separatorText("Depth of field");
        _ = ui.checkbox("On", &w.depth_of_field);
        ui.tooltip("The game's own depth of field. Its graphics setting has to be on too.", .{});
        {
            const off = ui.disabled(!w.depth_of_field);
            defer off.end();
            _ = ui.checkbox("Focus where the camera looks", &w.focus_on_target);
            ui.tooltip("On what the camera's aimed at, like the free camera's orbit. Off, at the distance below.", .{});
            if (!w.focus_on_target) {
                ui.setNextItemWidth(200);
                _ = ui.sliderWith("Focus distance", &w.focus_distance, 0.1, 100, .{ .format = "%.1f m", .logarithmic = true });
            }
            ui.setNextItemWidth(200);
            _ = ui.sliderWith("Sharp range", &w.sharp_range, 0, 50, .{ .format = "%.1f m", .logarithmic = true });
            ui.tooltip("How deep the sharp part is, around the focus.", .{});
            ui.setNextItemWidth(200);
            _ = ui.sliderWith("Blur over", &w.blur_over, 0.1, 100, .{ .format = "%.1f m", .logarithmic = true });
            ui.tooltip("How far past the sharp part it takes to blur fully.", .{});
            ui.setNextItemWidth(200);
            _ = ui.sliderWith("Blur size", &w.blur, 0, 10, .{ .format = "%.1f" });
            ui.tooltip("How big the blur gets. The game's is 3.", .{});
        }
        ui.separatorText("Filters");
        inline for (.{ .{ "Black and white", "monotone" }, .{ "Negative", "negative" }, .{ "Screen blur", "bokeh" } }) |f| {
            ui.setNextItemWidth(200);
            _ = ui.sliderWith(f[0], &@field(w, f[1]), 0, 1, .{ .format = if (@field(w, f[1]) > 0) "%.2f" else "Game's" });
            ui.tooltip("The game's own " ++ f[0] ++ " filter. 0 leaves it to the game.", .{});
        }
    }
};

/// Holds `at` at `value` while it's above 0, keeping the game's to put back once it's 0 again.
fn holdOrGive(game: *?GameEase, at: *Ease, value: f32) void {
    if (game.*) |g| if (g.at != at) {
        game.* = null;
    };
    if (value <= 0) {
        const g = game.* orelse return;
        at.* = g.ease;
        game.* = null;
        return;
    }
    if (game.* == null) game.* = .{ .at = at, .ease = at.* };
    hold(at, value);
}

/// There now, with no easing.
fn hold(e: *Ease, value: f32) void {
    e.from = value;
    e.to = value;
    e.now = value;
    e.time = 0;
    e.elapsed = 0;
}
