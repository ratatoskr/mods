//! HDR frames as EXR, through tinyexr.

const std = @import("std");
const sdk = @import("wraith_sdk");
const c = @import("exr");

pub const Encoded = struct {
    bytes: []u8,

    pub fn deinit(self: Encoded) void {
        std.c.free(self.bytes.ptr);
    }
};

/// Keeps the linear values as they are, so 1 is 80 nits like scRGB.
pub fn encode(allocator: std.mem.Allocator, linear: sdk.images.Linear) !Encoded {
    const count = linear.pixels.len;
    const planes = try allocator.alloc(f32, count * 3);
    defer allocator.free(planes);
    // EXR wants a plane per channel, and readers expect them sorted by name
    const names = [3][:0]const u8{ "B", "G", "R" };
    for (0..3) |i| {
        for (linear.pixels, 0..) |pixel, p| planes[count * i + p] = pixel[2 - i];
    }

    var channels: [3]c.exr_channel = @splat(std.mem.zeroes(c.exr_channel));
    for (&channels, names) |*channel, name| {
        @memcpy(channel.name[0..name.len], name);
        channel.pixel_type = c.EXR_PIXEL_FLOAT;
        channel.x_sampling = 1;
        channel.y_sampling = 1;
    }
    var header = std.mem.zeroes(c.exr_header);
    header.channels = &channels;
    header.num_channels = 3;
    header.part_type = c.EXR_PART_SCANLINE;
    header.compression = c.EXR_COMPRESSION_ZIP;
    header.data_window = .{ .min_x = 0, .min_y = 0, .max_x = @intCast(linear.width - 1), .max_y = @intCast(linear.height - 1) };
    header.display_window = header.data_window;
    header.pixel_aspect_ratio = 1;
    header.screen_window_width = 1;
    // Rec.709 primaries and D65 white
    header.has_chromaticities = 1;
    header.chromaticities = .{ 0.64, 0.33, 0.30, 0.60, 0.15, 0.06, 0.3127, 0.3290 };

    var writer: ?*c.exr_writer = null;
    try check(c.exr_writer_create(null, &writer));
    defer c.exr_writer_destroy(writer);
    try check(c.exr_writer_add_part(writer, &header, null));
    for (names, 0..) |name, i| try check(c.exr_writer_set_channel(writer, 0, name, planes[count * i ..].ptr));
    var data: ?*anyopaque = null;
    var size: usize = 0;
    try check(c.exr_writer_finalize_to_memory(writer, &data, &size));
    const bytes: [*]u8 = @ptrCast(data orelse return error.ExrFailed);
    return .{ .bytes = bytes[0..size] };
}

fn check(result: c.exr_result) !void {
    if (result == c.EXR_SUCCESS) return;
    if (result == c.EXR_ERROR_OUT_OF_MEMORY) return error.OutOfMemory;
    return error.ExrFailed;
}
