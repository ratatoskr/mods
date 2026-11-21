//! Save a screenshot to a folder. HDR games get an EXR too.

const std = @import("std");
const sdk = @import("wraith_sdk");
const exr = @import("exr.zig");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.screenshot);

pub const Settings = struct {
    key: ?sdk.keybinds.Chord = .{ .key = .f10 },
    include_overlay: bool = false,
    clipboard: bool = true,
    exr: bool = true,
    folder: []const u8 = "",
};

const default_folder = "Wraith";

const SettingsWindow = struct {
    window: sdk.ui.Window = .{ .title = "Screenshot##screenshot" },
    plugin: *Plugin = undefined,

    pub fn draw(self: *SettingsWindow) void {
        const p = self.plugin;
        const v = &p.settings.value;
        var changed = false;
        if (sdk.ui.chordInput("Key", &v.key, .{ .none = "No key" })) {
            p.applyKey();
            changed = true;
        }
        if (sdk.ui.checkbox("Include the overlay", &v.include_overlay)) changed = true;
        if (sdk.ui.checkbox("Copy to the clipboard", &v.clipboard)) changed = true;
        if (sdk.ui.checkbox("Save an EXR too in HDR games", &v.exr)) changed = true;
        sdk.ui.text("Folder", .{});
        sdk.ui.sameLine();
        if (v.folder.len > 0) sdk.ui.textDisabled("{s}", .{v.folder}) else sdk.ui.textDisabled("Pictures\\" ++ default_folder, .{});
        {
            const off = sdk.ui.disabled(p.browsing);
            defer off.end();
            if (sdk.ui.button("Browse...")) p.browse();
        }
        if (v.folder.len > 0) {
            sdk.ui.sameLine();
            if (sdk.ui.button("Default")) {
                v.folder = "";
                changed = true;
            }
        }
        if (changed) p.settings.save() catch |err| log.err("Couldn't save the settings: {t}", .{err});
    }
};

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    settings: *sdk.Config(Settings) = undefined,
    presses: sdk.keybinds.Presses = undefined,
    window: SettingsWindow = .{},
    /// The folder dialog's up.
    browsing: bool = false,

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        self.settings = try ctx.config(Settings);
        self.window.plugin = self;
        try ctx.addWindow(&self.window);
        ctx.settingsWindow(&self.window.window.open);
        self.presses = .init(ctx.io);
        if (self.settings.value.key) |chord| try self.presses.bind(action(chord));
        try ctx.spawn(takeShots, .{ self, ctx.io });
    }

    fn action(chord: sdk.keybinds.Chord) sdk.api.wraith.Action {
        return .{ .id = "take", .name = "Take screenshot", .chord = sdk.keybinds.chord(chord) };
    }

    fn applyKey(self: *Plugin) void {
        const chord = self.settings.value.key orelse return self.presses.unbind();
        self.presses.rebind(action(chord)) catch |err| log.err("Couldn't set the key: {t}", .{err});
    }

    fn browse(self: *Plugin) void {
        self.browsing = true;
        self.ctx.spawn(pickFolder, .{self}) catch |err| {
            self.browsing = false;
            log.err("Couldn't open the folder picker: {t}", .{err});
        };
    }

    fn pickFolder(self: *Plugin) !void {
        defer self.browsing = false;
        const picked = sdk.tasks.wait(self.ctx.wraith.ui().pickFolder(.{
            .title = .init("Where screenshots go"),
            .folder = .init(self.settings.value.folder),
        })) catch |err| switch (err) {
            error.Canceled, error.Gone => return err,
            else => return log.err("Couldn't pick a folder: {t}", .{err}),
        };
        const folder = picked orelse return;
        // Kept in the settings' arena so a screenshot being saved keeps its copy
        self.settings.value.folder = try self.settings.arena.allocator().dupe(u8, folder);
        self.settings.save() catch |err| log.err("Couldn't save the settings: {t}", .{err});
    }

    fn takeShots(self: *Plugin, io: std.Io) !void {
        while (true) {
            try self.presses.next(io);
            const options = self.settings.value;
            const point: sdk.api.wraith.CapturePoint = if (options.include_overlay) .after_overlay else .before_overlay;
            const capture = sdk.tasks.wait(self.ctx.wraith.frame().capture(point)) catch |err| switch (err) {
                error.Canceled, error.Gone => return err,
                else => {
                    _ = self.toast(0, .failure, "Couldn't capture the frame");
                    log.err("Couldn't capture the frame: {t}", .{err});
                    continue;
                },
            };
            defer capture.pixels.release();
            const busy = self.toast(0, .info, "Processing screenshot...");
            try sdk.frame.toWorker(io);
            const saved = save(self.ctx.allocator, io, capture, options);
            try sdk.frame.toRender(io);
            if (saved) {
                _ = self.toast(busy, .success, "Screenshot saved");
            } else |err| {
                if (err == error.Canceled) return err;
                _ = self.toast(busy, .failure, "Couldn't save the screenshot");
                log.err("Couldn't save the screenshot: {t}", .{err});
            }
        }
    }

    /// Replaces toast `id` if it's still up. Gives the one showing.
    fn toast(self: *Plugin, id: u32, kind: sdk.api.wraith.ToastKind, text: []const u8) u32 {
        const ui = self.ctx.wraith.ui();
        const t: sdk.api.wraith.Toast = .{ .kind = kind, .title = "Screenshot", .text = text, .seconds = if (kind == .info) 0 else 4 };
        if (id != 0 and ui.updateToast(id, t)) return id;
        return ui.toast(t);
    }
};

/// A PNG always, and an EXR with the full range for HDR if asked. Worker only.
fn save(allocator: std.mem.Allocator, io: std.Io, capture: sdk.api.wraith.Capture, options: Settings) !void {
    const linear = try sdk.images.linearFromCapture(allocator, .{
        .width = capture.width,
        .height = capture.height,
        .pitch = capture.pitch,
        .format = capture.format,
        .color_space = capture.color_space,
        .sdr_white_nits = capture.sdr_white_nits,
        .pixels = capture.pixels.bytes(),
    });
    defer linear.deinit(allocator);

    const folder = if (options.folder.len > 0) try allocator.dupe(u8, options.folder) else blk: {
        const pictures = try sdk.platform.fs.picturesDirAlloc(allocator);
        defer allocator.free(pictures);
        break :blk try std.fs.path.join(allocator, &.{ pictures, default_folder });
    };
    defer allocator.free(folder);
    try sdk.platform.fs.ensureDirectory(io, folder);
    const stamp = std.Io.Clock.real.now(io).toMilliseconds();

    const rgba = try linear.sdr(allocator, .{});
    defer rgba.deinit(allocator);
    if (options.clipboard) sdk.platform.clipboard.setImage(io, .{ .width = rgba.width, .height = rgba.height, .pixels = rgba.pixels }) catch |err| {
        if (err == error.Canceled) return err;
        log.err("Couldn't copy the screenshot to the clipboard: {t}", .{err});
    };
    const png = try sdk.images.encodePng(allocator, rgba);
    defer allocator.free(png);
    try write(allocator, io, folder, stamp, "png", png);

    if (options.exr and linear.hdr) {
        const encoded = try exr.encode(allocator, linear);
        defer encoded.deinit();
        try write(allocator, io, folder, stamp, "exr", encoded.bytes);
    }
}

fn write(allocator: std.mem.Allocator, io: std.Io, folder: []const u8, stamp: i64, extension: []const u8, bytes: []const u8) !void {
    const name = try std.fmt.allocPrint(allocator, "Screenshot-{d}.{s}", .{ stamp, extension });
    defer allocator.free(name);
    const path = try std.fs.path.join(allocator, &.{ folder, name });
    defer allocator.free(path);
    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = path, .data = bytes });
    log.info("Saved {s}", .{path});
}

comptime {
    sdk.exportPlugin(Plugin);
}
