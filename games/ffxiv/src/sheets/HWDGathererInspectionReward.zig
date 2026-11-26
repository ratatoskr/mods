//! `HWDGathererInspectionReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Scrips`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDGathererInspectionReward = @This();

pub const sheet_name = "HWDGathererInspectionReward";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(HWDGathererInspectionReward);

row: excel.Row,

pub fn scrips(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn points(self: @This()) u16 {
    return self.row.at(u16, 2);
}
