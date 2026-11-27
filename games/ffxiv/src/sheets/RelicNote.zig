//! `RelicNote`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `EventItem`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RelicNote = @This();

pub const sheet_name = "RelicNote";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb557320e;
pub const Sheet = excel.Typed(RelicNote);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EventItem", "MonsterNoteTargetCommon[0]", "MonsterCount[0]", "MonsterNoteTargetCommon[1]", "MonsterCount[1]", "MonsterNoteTargetCommon[2]", "MonsterCount[2]", "MonsterNoteTargetCommon[3]", "MonsterCount[3]", "MonsterNoteTargetCommon[4]", "MonsterCount[4]", "MonsterNoteTargetCommon[5]", "MonsterCount[5]", "MonsterNoteTargetCommon[6]", "MonsterCount[6]", "MonsterNoteTargetCommon[7]", "MonsterCount[7]", "MonsterNoteTargetCommon[8]", "MonsterCount[8]", "MonsterNoteTargetCommon[9]", "MonsterCount[9]", "MonsterNoteTargetNM[0]", "MonsterNoteTargetNM[1]", "MonsterNoteTargetNM[2]", "Unknown0", "Fate[0]", "PlaceNameFate[0]", "Fate[1]", "PlaceNameFate[1]", "Fate[2]", "PlaceNameFate[2]", "Leve[0]", "Leve[1]", "Leve[2]" };

/// Links to `EventItem`.
pub fn eventItem(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, 0));
}

pub const monster_note_target_common_len = 10;
/// Links to `MonsterNoteTarget`.
pub fn monsterNoteTargetCommon(self: @This(), n0: usize) excel.Link(sheets.MonsterNoteTarget) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub const monster_note_target_nm_len = 3;
/// Links to `MonsterNoteTarget`.
pub fn monsterNoteTargetNM(self: @This(), n0: usize) excel.Link(sheets.MonsterNoteTarget) {
    return .of(self.row.at(u16, offsets_2[n0]));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub const fate_len = 3;
/// Links to `Fate`.
pub fn fate(self: @This(), n0: usize) excel.Link(sheets.Fate) {
    return .of(self.row.at(u16, offsets_3[n0]));
}

pub const place_name_fate_len = 3;
/// Links to `PlaceName`.
pub fn placeNameFate(self: @This(), n0: usize) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, offsets_4[n0]));
}

pub const leve_len = 3;
/// Links to `Leve`.
pub fn leve(self: @This(), n0: usize) excel.Link(sheets.Leve) {
    return .of(self.row.at(u16, offsets_5[n0]));
}

pub const monster_count_len = 10;
pub fn monsterCount(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_6[n0]);
}

const offsets_1 = [10]u16{ 4, 6, 8, 10, 12, 14, 16, 18, 20, 22 };
const offsets_2 = [3]u16{ 24, 26, 28 };
const offsets_3 = [3]u16{ 32, 34, 36 };
const offsets_4 = [3]u16{ 38, 40, 42 };
const offsets_5 = [3]u16{ 44, 46, 48 };
const offsets_6 = [10]u16{ 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 };
