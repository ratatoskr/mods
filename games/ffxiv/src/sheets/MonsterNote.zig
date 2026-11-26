//! `MonsterNote`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MonsterNote = @This();

pub const sheet_name = "MonsterNote";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x50b4cd8f;
pub const Sheet = excel.Typed(MonsterNote);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn reward(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub const monster_note_target_len = 4;
/// Links to `MonsterNoteTarget`.
pub fn monsterNoteTarget(self: @This(), n0: usize) excel.Link(sheets.MonsterNoteTarget) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub const count_len = 4;
pub fn count(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

const offsets_1 = [4]u16{ 8, 10, 12, 14 };
const offsets_2 = [4]u16{ 16, 17, 18, 19 };
