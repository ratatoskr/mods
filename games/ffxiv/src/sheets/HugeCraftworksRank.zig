//! `HugeCraftworksRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HugeCraftworksRank = @This();

pub const sheet_name = "HugeCraftworksRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf7af7ac5;
pub const Sheet = excel.Typed(HugeCraftworksRank);

row: excel.Row,

pub fn expRewardPerItem(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn crafterLevel(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 5);
}
