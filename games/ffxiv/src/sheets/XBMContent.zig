//! `XBMContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMContent = @This();

pub const sheet_name = "XBMContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd19cff9a;
pub const Sheet = excel.Typed(XBMContent);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ContentFinderCondition", "TeamSize", "RecommendedRank", "SyncRank", "BonusPoints[0]", "BonusPoints[1]", "BonusPoints[2]", "BonusPoints[3]", "BonusPoints[4]", "BonusPoints[5]", "BonusPoints[6]", "BonusPoints[7]", "BonusPoints[8]", "BonusPoints[9]", "BonusPoints[10]", "BonusPoints[11]", "BonusPoints[12]", "BonusPoints[13]", "BonusPoints[14]", "BonusPoints[15]", "BonusPoints[16]", "BonusPoints[17]", "BonusPoints[18]", "BonusPoints[19]", "BonusPoints[20]", "BonusPoints[21]", "BonusPoints[22]", "BonusPoints[23]", "BonusPoints[24]", "BonusPoints[25]", "BonusPoints[26]", "BonusPoints[27]", "BonusPoints[28]", "BonusPoints[29]", "BonusPoints[30]", "BonusPoints[31]", "BonusPoints[32]" };

pub const bonus_points_len = 33;
/// The array indices map to the rows in XBMScoreBonus
pub fn bonusPoints(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_1[n0]);
}

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u16, 66));
}

pub fn teamSize(self: @This()) u8 {
    return self.row.at(u8, 68);
}

/// Take this value subtract 2. It is how the exe is doing it.
pub fn recommendedRank(self: @This()) u8 {
    return self.row.at(u8, 69);
}

pub fn syncRank(self: @This()) u8 {
    return self.row.at(u8, 70);
}

const offsets_1 = [33]u16{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64 };
