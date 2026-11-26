//! A row, or one subrow, as a view of its page. Nothing's copied or decoded till a column's read,
//! and it lasts as long as its sheet.

const Row = @This();

const std = @import("std");

const Header = @import("Header.zig");

header: *const Header,
id: u32,
/// Always 0 in a sheet of plain rows.
subrow: u16,
/// The whole row: its columns, or every subrow's, then its strings.
bytes: []const u8,
/// Where this one's columns start in `bytes`.
base: usize,
/// Where the strings start in `bytes`, after every subrow's columns.
strings: usize,

pub const Error = error{ NoColumn, Corrupt };

pub const Value = union(enum) {
    /// An SeString, with the game's macros and payloads still in it.
    string: []const u8,
    bool: bool,
    i8: i8,
    u8: u8,
    i16: i16,
    u16: u16,
    i32: i32,
    u32: u32,
    f32: f32,
    i64: i64,
    u64: u64,
};

/// The column at `index` in its header.
pub fn column(self: Row, index: usize) Error!Value {
    if (index >= self.header.columns.len) return error.NoColumn;
    const c = self.header.columns[index];
    if (c.type.bit()) |b| return .{ .bool = try self.flag(c.offset, b) };
    return switch (c.type) {
        .string => .{ .string = try self.string(c.offset) },
        .bool => .{ .bool = try self.int(u8, c.offset) != 0 },
        .i8 => .{ .i8 = try self.int(i8, c.offset) },
        .u8 => .{ .u8 = try self.int(u8, c.offset) },
        .i16 => .{ .i16 = try self.int(i16, c.offset) },
        .u16 => .{ .u16 = try self.int(u16, c.offset) },
        .i32 => .{ .i32 = try self.int(i32, c.offset) },
        .u32 => .{ .u32 = try self.int(u32, c.offset) },
        .f32 => .{ .f32 = @bitCast(try self.int(u32, c.offset)) },
        .i64 => .{ .i64 = try self.int(i64, c.offset) },
        .u64 => .{ .u64 = try self.int(u64, c.offset) },
        else => error.Corrupt,
    };
}

/// The int at `offset` in its columns, for code that knows the layout.
pub fn int(self: Row, comptime T: type, offset: usize) Error!T {
    return std.mem.readInt(T, (try self.fixed(offset, @sizeOf(T)))[0..@sizeOf(T)], .big);
}

pub fn float(self: Row, offset: usize) Error!f32 {
    return @bitCast(try self.int(u32, offset));
}

pub fn flag(self: Row, offset: usize, bit: u3) Error!bool {
    return (try self.int(u8, offset)) & (@as(u8, 1) << bit) != 0;
}

/// The string the offset at `offset` points to. Strings come after the columns, and every subrow's
/// are counted from the end of the last one's.
pub fn string(self: Row, offset: usize) Error![]const u8 {
    const start = std.math.add(usize, self.strings, try self.int(u32, offset)) catch return error.Corrupt;
    if (start > self.bytes.len) return error.Corrupt;
    const end = std.mem.indexOfScalarPos(u8, self.bytes, start, 0) orelse return error.Corrupt;
    return self.bytes[start..end];
}

fn fixed(self: Row, offset: usize, len: usize) Error![]const u8 {
    if (offset + len > self.header.row_size) return error.Corrupt;
    const start = self.base + offset;
    if (start + len > self.bytes.len) return error.Corrupt;
    return self.bytes[start..][0..len];
}

/// Whether all its columns are there. Typed sheets check this once per row, so `at` and the
/// others after can't fail.
pub fn fits(self: Row) bool {
    return self.base + self.header.row_size <= self.bytes.len and self.strings <= self.bytes.len;
}

/// For a row that `fits`, at an offset in its columns.
pub fn at(self: Row, comptime T: type, offset: u16) T {
    if (T == f32) return @bitCast(self.at(u32, offset));
    std.debug.assert(offset + @sizeOf(T) <= self.header.row_size);
    return std.mem.readInt(T, self.bytes[self.base + offset ..][0..@sizeOf(T)], .big);
}

pub fn bitAt(self: Row, offset: u16, bit: u3) bool {
    return self.at(u8, offset) & (@as(u8, 1) << bit) != 0;
}

/// Empty if the string's offset is bad.
pub fn stringAt(self: Row, offset: u16) []const u8 {
    return self.string(offset) catch "";
}

test "reads its columns" {
    const t = std.testing;
    var columns = [_]Header.Column{
        .{ .type = .string, .offset = 0 },
        .{ .type = .u16, .offset = 4 },
        .{ .type = .packed_bool1, .offset = 6 },
        .{ .type = .f32, .offset = 8 },
    };
    const header: Header = .{ .kind = .rows, .row_size = 12, .columns = &columns, .pages = &.{}, .languages = &.{} };
    const row: Row = .{ .header = &header, .id = 1, .subrow = 0, .base = 0, .strings = 12, .bytes = "\x00\x00\x00\x01" ++ "\x06\x87" ++ "\x02\x00" ++ "\x40\x8b\xb2\x3e" ++ "\x00hi\x00" };
    try t.expectEqualStrings("hi", (try row.column(0)).string);
    try t.expectEqual(1671, (try row.column(1)).u16);
    try t.expectEqual(true, (try row.column(2)).bool);
    try t.expectApproxEqAbs(4.3655, (try row.column(3)).f32, 0.0001);
    try t.expectError(error.NoColumn, row.column(4));
    // Past its columns, into the strings
    try t.expectError(error.Corrupt, row.int(u32, 10));
}
