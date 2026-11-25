//! Raw deflate, through libdeflate (deflate.c). Every block in a dat is a small one whose sizes are
//! known up front, which is what it's best at, and it's over twice as quick as
//! `std.compress.flate` on them.

const Inflater = @This();

const std = @import("std");

/// Room for libdeflate's decompressor, which `ffxiv_inflater_size` checks.
const state_size = 12 * 1024;

/// Zeroed is how libdeflate starts one.
state: [state_size]u8 align(64) = @splat(0),

/// `in` unpacked into all of `out`, which has to be exactly its size.
pub fn inflate(self: *Inflater, in: []const u8, out: []u8) error{Corrupt}!void {
    std.debug.assert(ffxiv_inflater_size() <= state_size);
    if (ffxiv_inflate(&self.state, in.ptr, in.len, out.ptr, out.len) != 0) return error.Corrupt;
}

extern fn ffxiv_inflater_size() usize;
extern fn ffxiv_inflate(state: *anyopaque, in: [*]const u8, in_len: usize, out: [*]u8, out_len: usize) c_int;

fn compressed(gpa: std.mem.Allocator, data: []const u8) ![]u8 {
    const flate = std.compress.flate;
    // Its compressor wants room up front
    var out: std.Io.Writer.Allocating = try .initCapacity(gpa, data.len + 1024);
    errdefer out.deinit();
    const window = try gpa.alloc(u8, flate.max_window_len);
    defer gpa.free(window);
    var c: flate.Compress = try .init(&out.writer, window, .raw, .default);
    try c.writer.writeAll(data);
    try c.finish();
    return out.toOwnedSlice();
}

test "unpacks what std packs, and only to its size" {
    const t = std.testing;
    try t.expect(ffxiv_inflater_size() <= state_size);
    var self: Inflater = .{};
    var data: [20000]u8 = undefined;
    for (&data, 0..) |*b, i| b.* = @intCast((i * 7 + i / 13) % 251);
    const packed_data = try compressed(t.allocator, &data);
    defer t.allocator.free(packed_data);

    var out: [data.len + 1]u8 = undefined;
    try self.inflate(packed_data, out[0..data.len]);
    try t.expectEqualSlices(u8, &data, out[0..data.len]);
    try t.expectError(error.Corrupt, self.inflate(packed_data, &out));
    try t.expectError(error.Corrupt, self.inflate(packed_data, out[0 .. data.len - 1]));
    try t.expectError(error.Corrupt, self.inflate(packed_data[0 .. packed_data.len / 2], out[0..data.len]));
}
