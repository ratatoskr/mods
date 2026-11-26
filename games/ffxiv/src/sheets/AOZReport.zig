//! `AOZReport`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZReport = @This();

pub const sheet_name = "AOZReport";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1a97b0af;
pub const Sheet = excel.Typed(AOZReport);

row: excel.Row,

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u32, 0));
}

/// Links to `AOZReportReward`.
pub fn reward(self: @This()) excel.Link(sheets.AOZReportReward) {
    return .of(self.row.at(u8, 4));
}

pub fn order(self: @This()) i8 {
    return self.row.at(i8, 5);
}
