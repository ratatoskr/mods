//! `AOZWeeklyReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZWeeklyReward = @This();

pub const sheet_name = "AOZWeeklyReward";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdc23efe7;
pub const Sheet = excel.Typed(AOZWeeklyReward);

row: excel.Row,

pub fn gilReward(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn alliedSealsReward(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn tomestonesReward(self: @This()) u16 {
    return self.row.at(u16, 4);
}
