//! One `ccrrkk.win32.*` set of files, with `cc` its category, `rr` its repo and `kk` the chunk.
//! Big categories like `bg` are split over a few. It's its indexes, and the dats they point into.

const Chunk = @This();

const std = @import("std");
const File = std.Io.File;

const format = @import("format.zig");
const index = @import("index.zig");
const Path = @import("Path.zig");
const unpack = @import("unpack.zig");

id: u8,
index1: ?index.Index1,
index2: ?index.Index2,
dats: []File,

/// `stem` is like `040000.win32`. Needs at least one of its indexes, and every dat they point into.
pub fn open(io: std.Io, gpa: std.mem.Allocator, dir: std.Io.Dir, id: u8, stem: []const u8) !Chunk {
    var name_buf: [32]u8 = undefined;
    var index1 = try openIndex(index.Index1, io, dir, try std.fmt.bufPrint(&name_buf, "{s}.index", .{stem}));
    errdefer if (index1) |*i| i.close(io);
    var index2 = try openIndex(index.Index2, io, dir, try std.fmt.bufPrint(&name_buf, "{s}.index2", .{stem}));
    errdefer if (index2) |*i| i.close(io);
    const dat_count = if (index1) |i| i.dat_count else if (index2) |i| i.dat_count else return error.FileNotFound;

    const dats = try gpa.alloc(File, dat_count);
    errdefer gpa.free(dats);
    var opened: usize = 0;
    errdefer for (dats[0..opened]) |f| f.close(io);
    for (dats, 0..) |*f, n| {
        f.* = try dir.openFile(io, try std.fmt.bufPrint(&name_buf, "{s}.dat{d}", .{ stem, n }), .{});
        opened += 1;
    }
    return .{ .id = id, .index1 = index1, .index2 = index2, .dats = dats };
}

fn openIndex(comptime I: type, io: std.Io, dir: std.Io.Dir, name: []const u8) !?I {
    return I.open(io, dir, name) catch |err| switch (err) {
        error.FileNotFound => null,
        else => err,
    };
}

pub fn close(self: *Chunk, io: std.Io, gpa: std.mem.Allocator) void {
    for (self.dats) |f| f.close(io);
    gpa.free(self.dats);
    if (self.index1) |*i| i.close(io);
    if (self.index2) |*i| i.close(io);
}

/// Its entry's data, by `.index` like the game, or `.index2` if that's all there is.
pub fn find(self: *const Chunk, path: *const Path) ?u32 {
    if (self.index1) |*i| return i.find(path.hash1, path.text());
    if (self.index2) |*i| return i.find(path.hash2, path.text());
    return null;
}

/// The file an entry's data points at, unpacked. Free it with `gpa`.
pub fn read(self: *const Chunk, io: std.Io, gpa: std.mem.Allocator, data: u32) ![]u8 {
    const dat = format.datOf(data);
    if (dat >= self.dats.len) return error.Corrupt;
    return unpack.read(io, gpa, self.dats[dat], format.offsetOf(data));
}
