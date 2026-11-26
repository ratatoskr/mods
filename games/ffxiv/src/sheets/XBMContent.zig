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
