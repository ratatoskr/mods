//! Save a screenshot to a folder. HDR games get an EXR too.

const std = @import("std");
const sdk = @import("wraith_sdk");
const exr = @import("exr.zig");

pub const std_options: std.Options = .{ .logFn = sdk.logFn };
pub const panic = sdk.panic;

const log = sdk.log.scoped(.screenshot);

const W = sdk.api.wraith;

/// Its settings, in Wraith's Settings under its name. Its key is in Keybinds.
const Options = struct {
    include_overlay: bool,
    clipboard: bool,
    exr: bool,
    /// Empty is `Pictures\Wraith`.
    folder: []const u8,
};

const default_folder = "Wraith";

pub const Plugin = struct {
    ctx: *sdk.Context = undefined,
    presses: sdk.keybinds.Presses = undefined,
    include_overlay: W.Setting = undefined,
    clipboard: W.Setting = undefined,
    exr: W.Setting = undefined,
    folder: W.Setting = undefined,

    pub fn start(self: *Plugin, ctx: *sdk.Context) !void {
        self.ctx = ctx;
        const settings = ctx.wraith.settings();
        self.include_overlay = try settings.add(.{ .id = "include_overlay", .name = "Include the overlay", .kind = .toggle }, null);
        self.clipboard = try settings.add(.{ .id = "clipboard", .name = "Copy to the clipboard", .kind = .toggle, .has_default = true, .default_value = .{ .toggle = true } }, null);
        self.exr = try settings.add(.{ .id = "exr", .name = "Save an EXR too in HDR games", .help = "Keeps the full HDR range, next to the PNG.", .kind = .toggle, .has_default = true, .default_value = .{ .toggle = true } }, null);
        self.folder = try settings.add(.{ .id = "folder", .name = "Folder", .help = "Where screenshots go.", .kind = .path, .placeholder = "Pictures\\" ++ default_folder }, null);
        self.presses = .init(ctx.io);
        try self.presses.bind(.{ .id = "take", .name = "Take screenshot", .chord = sdk.keybinds.chord(.{ .key = .f10 }) });
        try ctx.spawn(takeShots, .{ self, ctx.io });
    }

    /// As they are now, the folder copied into `allocator`.
    fn readOptions(self: *Plugin, allocator: std.mem.Allocator) !Options {
        return .{
            .include_overlay = (try self.include_overlay.get()).toggle,
            .clipboard = (try self.clipboard.get()).toggle,
            .exr = (try self.exr.get()).toggle,
            .folder = try allocator.dupe(u8, (try self.folder.get()).text),
        };
    }
    fn takeShots(self: *Plugin, io: std.Io) !void {
        while (true) {
            try self.presses.next(io);
            const options = self.readOptions(self.ctx.allocator) catch |err| {
                log.err("Couldn't read the settings: {t}", .{err});
                continue;
            };
            defer self.ctx.allocator.free(options.folder);
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
fn save(allocator: std.mem.Allocator, io: std.Io, capture: sdk.api.wraith.Capture, options: Options) !void {
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
