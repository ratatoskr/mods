//! A sheet's `.exh`: its columns, which pages its rows are split over, and its languages. Big endian.

const Header = @This();

const std = @import("std");

pub const Kind = enum(u8) {
    /// One row per id.
    rows = 1,
    /// Each id has a run of subrows, all the same shape.
    subrows = 2,
    _,
};

pub const ColumnType = enum(u16) {
    string = 0x0,
    bool = 0x1,
    i8 = 0x2,
    u8 = 0x3,
    i16 = 0x4,
    u16 = 0x5,
    i32 = 0x6,
    u32 = 0x7,
    f32 = 0x9,
    i64 = 0xA,
    u64 = 0xB,
    /// Bits of a byte, from 0 up. Several columns share the byte.
    packed_bool0 = 0x19,
    packed_bool1 = 0x1A,
    packed_bool2 = 0x1B,
    packed_bool3 = 0x1C,
    packed_bool4 = 0x1D,
    packed_bool5 = 0x1E,
    packed_bool6 = 0x1F,
    packed_bool7 = 0x20,
    _,

    /// How many bytes it takes in a row. Strings are a u32 offset to them.
    pub fn size(self: ColumnType) ?u8 {
        return switch (self) {
            .bool, .i8, .u8 => 1,
            .i16, .u16 => 2,
            .string, .i32, .u32, .f32 => 4,
            .i64, .u64 => 8,
            .packed_bool0, .packed_bool1, .packed_bool2, .packed_bool3, .packed_bool4, .packed_bool5, .packed_bool6, .packed_bool7 => 1,
            _ => null,
        };
    }

    /// Which bit, for a packed bool.
    pub fn bit(self: ColumnType) ?u3 {
        const n = @backingInt(self);
        if (n < @backingInt(ColumnType.packed_bool0) or n > @backingInt(ColumnType.packed_bool7)) return null;
        return @intCast(n - @backingInt(ColumnType.packed_bool0));
    }
};

pub const Column = struct {
    type: ColumnType,
    /// From the start of the row, or of each subrow.
    offset: u16,
};

/// The rows from `start` on that are in one `.exd`.
pub const Page = struct {
    start: u32,
    count: u32,
};

pub const Language = enum(u8) {
    /// For sheets that aren't translated.
    none = 0,
    japanese = 1,
    english = 2,
    german = 3,
    french = 4,
    chinese_simplified = 5,
    chinese_traditional = 6,
    korean = 7,
    chinese_traditional2 = 8,
    _,

    /// What goes after a page's name, like `_en`.
    pub fn suffix(self: Language) ?[]const u8 {
        return switch (self) {
            .none => "",
            .japanese => "_ja",
            .english => "_en",
            .german => "_de",
            .french => "_fr",
            .chinese_simplified => "_chs",
            .chinese_traditional => "_cht",
            .korean => "_ko",
            .chinese_traditional2 => "_tc",
            _ => null,
        };
    }
};

kind: Kind,
/// How big each row's columns are, before its strings. Each subrow's too.
row_size: u16,
columns: []Column,
pages: []Page,
languages: []Language,

pub const ParseError = error{ NotExcelHeader, Truncated, OutOfMemory };

pub fn parse(gpa: std.mem.Allocator, bytes: []const u8) ParseError!Header {
    if (bytes.len < 32) return error.Truncated;
    if (!std.mem.eql(u8, bytes[0..4], "EXHF")) return error.NotExcelHeader;
    const column_count = int(u16, bytes, 8);
    const page_count = int(u16, bytes, 10);
    const language_count = int(u16, bytes, 12);
    const pages_at = 32 + @as(usize, column_count) * 4;
    const languages_at = pages_at + @as(usize, page_count) * 8;
    if (bytes.len < languages_at + @as(usize, language_count) * 2) return error.Truncated;

    const columns = try gpa.alloc(Column, column_count);
    errdefer gpa.free(columns);
    for (columns, 0..) |*c, i| c.* = .{ .type = @fromBackingInt(@intCast(int(u16, bytes, 32 + i * 4))), .offset = int(u16, bytes, 34 + i * 4) };
    const pages = try gpa.alloc(Page, page_count);
    errdefer gpa.free(pages);
    for (pages, 0..) |*p, i| p.* = .{ .start = int(u32, bytes, pages_at + i * 8), .count = int(u32, bytes, pages_at + i * 8 + 4) };
    // Each is a byte then a spare one
    const languages = try gpa.alloc(Language, language_count);
    for (languages, 0..) |*l, i| l.* = @fromBackingInt(@intCast(bytes[languages_at + i * 2]));

    return .{
        .kind = @fromBackingInt(@intCast(bytes[17])),
        .row_size = int(u16, bytes, 6),
        .columns = columns,
        .pages = pages,
        .languages = languages,
    };
}

pub fn deinit(self: *Header, gpa: std.mem.Allocator) void {
    gpa.free(self.columns);
    gpa.free(self.pages);
    gpa.free(self.languages);
    self.* = undefined;
}

pub fn has(self: *const Header, language: Language) bool {
    return std.mem.indexOfScalar(Language, self.languages, language) != null;
}

/// The CRC-32 of its columns, as other tools have it, to tell when a patch changes them.
pub fn columnsHash(self: *const Header) u32 {
    var crc: std.hash.crc.@"CRC-32/JAMCRC" = .init();
    for (self.columns) |c| {
        var buf: [4]u8 = undefined;
        std.mem.writeInt(u16, buf[0..2], @backingInt(c.type), .big);
        std.mem.writeInt(u16, buf[2..4], c.offset, .big);
        crc.update(&buf);
    }
    return crc.final();
}

/// How many row ids there are, not counting subrows.
pub fn rowCount(self: *const Header) usize {
    var total: usize = 0;
    for (self.pages) |p| total += p.count;
    return total;
}

fn int(comptime T: type, bytes: []const u8, at: usize) T {
    return std.mem.readInt(T, bytes[at..][0..@sizeOf(T)], .big);
}

test "parses a header" {
    const t = std.testing;
    // 2 columns, 1 page, 2 languages, plain rows of 8 bytes
    const bytes = "EXHF" ++ "\x00\x03" ++ "\x00\x08" ++ "\x00\x02" ++ "\x00\x01" ++ "\x00\x02" ++ "\x00\x00\x00" ++ "\x01" ++ "\x00\x00" ++ "\x00\x00\x00\x05" ++ "\x00\x00\x00\x00\x00\x00\x00\x00" ++
        "\x00\x00\x00\x00" ++ "\x00\x19\x00\x04" ++
        "\x00\x00\x00\x00\x00\x00\x00\x05" ++
        "\x01\x00\x02\x00";
    var h = try parse(t.allocator, bytes);
    defer h.deinit(t.allocator);
    try t.expectEqual(.rows, h.kind);
    try t.expectEqual(8, h.row_size);
    try t.expectEqual(Column{ .type = .packed_bool0, .offset = 4 }, h.columns[1]);
    try t.expectEqual(0, h.columns[1].type.bit());
    try t.expectEqual(Page{ .start = 0, .count = 5 }, h.pages[0]);
    try t.expect(h.has(.english) and !h.has(.none));
    try t.expectError(error.Truncated, parse(t.allocator, bytes[0 .. bytes.len - 1]));
    try t.expectError(error.NotExcelHeader, parse(t.allocator, "EXDF" ++ bytes[4..]));
}
