//! `XBMPetParamGrow`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMPetParamGrow = @This();

pub const sheet_name = "XBMPetParamGrow";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x64a88f98;
pub const Sheet = excel.Typed(XBMPetParamGrow);

row: excel.Row,

pub fn strength(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn intelligence(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn physicalResistance(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn magicalResistance(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn constitution(self: @This()) u16 {
    return self.row.at(u16, 8);
}
