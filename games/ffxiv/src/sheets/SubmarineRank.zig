//! `SubmarineRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SubmarineRank = @This();

pub const sheet_name = "SubmarineRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x697b9c75;
pub const Sheet = excel.Typed(SubmarineRank);

row: excel.Row,

pub fn expToNext(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn capacity(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn surveillanceBonus(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn retrievalBonus(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn speedBonus(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn rangeBonus(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn favorBonus(self: @This()) u8 {
    return self.row.at(u8, 10);
}
