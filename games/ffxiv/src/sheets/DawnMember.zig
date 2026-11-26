//! `DawnMember`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DawnMember = @This();

pub const sheet_name = "DawnMember";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xde74b4c4;
pub const Sheet = excel.Typed(DawnMember);

row: excel.Row,

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 1);
}
