//! `Carry`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Carry = @This();

pub const sheet_name = "Carry";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x31e1f9e6;
pub const Sheet = excel.Typed(Carry);

row: excel.Row,

pub fn model(self: @This()) u64 {
    return self.row.at(u64, 0);
}

pub fn timeline(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 10);
}
