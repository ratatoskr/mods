//! `MKDSupportJob`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MKDSupportJob = @This();

pub const sheet_name = "MKDSupportJob";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd5478a4;
pub const Sheet = excel.Typed(MKDSupportJob);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "NameShort", "NameFemale", "Description", "NameEnglish", "LevelMax", "JobIndex", "LevelUnlock[0]", "Action[0]", "LevelUnlock[1]", "Action[1]", "LevelUnlock[2]", "Action[2]", "LevelUnlock[3]", "Action[3]", "LevelUnlock[4]", "Action[4]" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn nameShort(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn nameFemale(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn nameEnglish(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub const action_len = 5;
/// Links to `Action`.
pub fn action(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn levelMax(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn jobIndex(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub const level_unlock_len = 5;
pub fn levelUnlock(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

const offsets_1 = [5]u16{ 20, 24, 28, 32, 36 };
const offsets_2 = [5]u16{ 42, 43, 44, 45, 46 };
