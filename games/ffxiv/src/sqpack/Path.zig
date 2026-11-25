//! A game file's path, like `chara/equipment/e0436/model/c0101e0436_top.mdl`, and the hashes its
//! indexes find it by. The game lowercases them first, so case doesn't matter.

const Path = @This();

const std = @import("std");

/// The longest a synonym list can hold, so the longest that can always be found.
pub const max_len = 0xF0;

/// The game's CRC-32.
pub const Crc = std.hash.crc.@"CRC-32/JAMCRC";

/// The first part of a path, and the first two hex digits of its files' names.
pub const Category = enum(u8) {
    common = 0x00,
    bgcommon = 0x01,
    bg = 0x02,
    cut = 0x03,
    chara = 0x04,
    shader = 0x05,
    ui = 0x06,
    sound = 0x07,
    vfx = 0x08,
    ui_script = 0x09,
    exd = 0x0A,
    game_script = 0x0B,
    music = 0x0C,
    sqpack_test = 0x12,
    debug = 0x13,
};

buf: [max_len]u8,
len: u8,
category: Category,
/// 0 is the base game's `ffxiv`, the rest are `exN`, from paths like `bg/ex3/...`.
repo: u8,
/// The folder's hash on top, the file name's below, for `.index`.
hash1: u64,
/// The whole path's, for `.index2`.
hash2: u32,

pub const ParseError = error{ PathTooLong, NoCategory, UnknownCategory };

pub fn parse(raw: []const u8) ParseError!Path {
    if (raw.len > max_len) return error.PathTooLong;
    var self: Path = undefined;
    self.len = @intCast(raw.len);
    const lower = std.ascii.lowerString(&self.buf, raw);

    const slash = std.mem.indexOfScalar(u8, lower, '/') orelse return error.NoCategory;
    self.category = std.meta.stringToEnum(Category, lower[0..slash]) orelse return error.UnknownCategory;
    self.repo = repoOf(lower[slash + 1 ..]);

    const last = std.mem.lastIndexOfScalar(u8, lower, '/').?;
    self.hash1 = (@as(u64, Crc.hash(lower[0..last])) << 32) | Crc.hash(lower[last + 1 ..]);
    self.hash2 = Crc.hash(lower);
    return self;
}

/// Lowercase, as it's hashed.
pub fn text(self: *const Path) []const u8 {
    return self.buf[0..self.len];
}

/// `exN` as the second part means that expansion, anything else is the base game.
fn repoOf(rest: []const u8) u8 {
    const end = std.mem.indexOfScalar(u8, rest, '/') orelse return 0;
    const part = rest[0..end];
    if (!std.mem.startsWith(u8, part, "ex")) return 0;
    return std.fmt.parseInt(u8, part[2..], 10) catch 0;
}

test "hashes match the game's" {
    const t = std.testing;
    try t.expectEqual(0xa2850653, Crc.hash("chara/equipment/e0633/material/v0010/mt_c0101e0633_met_a.mtrl"));

    const ex = try parse("chara/ex6/beep.dat");
    try t.expectEqual(.chara, ex.category);
    try t.expectEqual(6, ex.repo);
    try t.expectEqual(0x2e7e889c54cbce06, ex.hash1);
    try t.expectEqual(0xbed04397, ex.hash2);

    // Case doesn't matter, and without exN it's the base game's
    const base = try parse("cHAra/bEEp.daT");
    try t.expectEqual(0, base.repo);
    try t.expectEqual(0x7774313e54cbce06, base.hash1);
    try t.expectEqual(0x32ca2200, base.hash2);
    try t.expectEqualStrings("chara/beep.dat", base.text());

    // Just a folder still hashes, with an empty name
    const folder = try parse("chara/ex6/folder/");
    try t.expectEqual(0xb811ed45ffffffff, folder.hash1);
    try t.expectEqual(0xaddf99ab, folder.hash2);

    // A folder that only starts with ex isn't an expansion
    try t.expectEqual(0, (try parse("exd/exversion.exh")).repo);
    try t.expectEqual(0, (try parse("bg/extra/a.sgb")).repo);
}

test "paths it can't take" {
    const t = std.testing;
    try t.expectError(error.NoCategory, parse("chara"));
    try t.expectError(error.UnknownCategory, parse("beep/ex6/test.dat"));
    const long: [max_len + 1]u8 = @splat('a');
    try t.expectError(error.PathTooLong, parse(&long));
}
