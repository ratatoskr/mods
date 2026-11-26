//! `WKSScoreList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSScoreList = @This();

pub const sheet_name = "WKSScoreList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x98ec27dc;
pub const Sheet = excel.Typed(WKSScoreList);

row: excel.Row,

/// Links to `Item`.
pub fn scoreItemId(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Achievement`.
pub fn achievement50k(self: @This()) excel.Link(sheets.Achievement) {
    return .of(self.row.at(u16, 4));
}

/// Links to `Achievement`.
pub fn achievement150k(self: @This()) excel.Link(sheets.Achievement) {
    return .of(self.row.at(u16, 6));
}

/// Links to `Achievement`.
pub fn achievement500k(self: @This()) excel.Link(sheets.Achievement) {
    return .of(self.row.at(u16, 8));
}

/// Links to `Achievement`.
pub fn masteryAchievement(self: @This()) excel.Link(sheets.Achievement) {
    return .of(self.row.at(u16, 10));
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 12);
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(i8, 13));
}
