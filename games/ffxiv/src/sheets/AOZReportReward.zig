//! `AOZReportReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZReportReward = @This();

pub const sheet_name = "AOZReportReward";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf9a9de3d;
pub const Sheet = excel.Typed(AOZReportReward);

row: excel.Row,

pub fn firstGilReward(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn generalGilReward(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn firstAlliedSealsReward(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn firstTomestonesReward(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn generalAlliedSealsReward(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn generalTomestonesReward(self: @This()) u16 {
    return self.row.at(u16, 14);
}
