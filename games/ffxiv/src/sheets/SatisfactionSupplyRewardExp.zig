//! `SatisfactionSupplyRewardExp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SatisfactionSupplyRewardExp = @This();

pub const sheet_name = "SatisfactionSupplyRewardExp";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xfd08b3c9;
pub const Sheet = excel.Typed(SatisfactionSupplyRewardExp);

row: excel.Row,

pub fn percentOfLevelLow(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn percentOfLevelMid(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn percentOfLevelHigh(self: @This()) u8 {
    return self.row.at(u8, 2);
}
