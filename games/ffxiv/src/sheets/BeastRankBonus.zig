//! `BeastRankBonus`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BeastRankBonus = @This();

pub const sheet_name = "BeastRankBonus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4d6cbdc3;
pub const Sheet = excel.Typed(BeastRankBonus);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub fn neutral(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn recognized(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn friendly(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn trusted(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn respected(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn honored(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn sworn(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn alliedBloodsworn(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub const item_quantity_len = 8;
pub fn itemQuantity(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_1[n0]);
}

const offsets_1 = [8]u16{ 20, 21, 22, 23, 24, 25, 26, 27 };
