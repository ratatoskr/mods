//! `WeddingFlowerColor`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeddingFlowerColor = @This();

pub const sheet_name = "WeddingFlowerColor";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfd08b3c9;
pub const Sheet = excel.Typed(WeddingFlowerColor);

row: excel.Row,

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 2);
}
