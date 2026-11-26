//! `ZoneSharedGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ZoneSharedGroup = @This();

pub const sheet_name = "ZoneSharedGroup";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xfa71ca60;
pub const Sheet = excel.Typed(ZoneSharedGroup);

row: excel.Row,

pub fn lgbSharedGroup(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub const requirement_row_len = 6;
/// Links to `Quest`, `AetherCurrent`, `EurekaStoryProgress` or `DomaStoryProgress`, whichever has the row.
pub fn requirementRow(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub const requirement_quest_sequence_len = 6;
pub fn requirementQuestSequence(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_2[n0]);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 56);
}

pub const requirement_type_len = 6;
/// 1 = Quest
/// 2 = Quest with specific Sequence
/// 3 = AetherCurrent
/// 4 = EurekaStoryProgress
/// 5 = DomaStoryProgress
pub fn requirementType(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_3[n0]);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 66);
}

pub fn unknown9(self: @This()) bool {
    return self.row.at(u8, 67) != 0;
}

pub fn unknown10(self: @This()) bool {
    return self.row.at(u8, 68) != 0;
}

pub fn unknown11(self: @This()) bool {
    return self.row.at(u8, 69) != 0;
}

pub fn unknown12(self: @This()) bool {
    return self.row.at(u8, 70) != 0;
}

pub fn unknown13(self: @This()) bool {
    return self.row.at(u8, 71) != 0;
}

pub fn unknown14(self: @This()) bool {
    return self.row.at(u8, 72) != 0;
}

pub fn unknown15(self: @This()) bool {
    return self.row.at(u8, 73) != 0;
}

const offsets_1 = [6]u16{ 4, 8, 12, 16, 20, 24 };
const offsets_2 = [6]u16{ 32, 36, 40, 44, 48, 52 };
const offsets_3 = [6]u16{ 60, 61, 62, 63, 64, 65 };
