//! `MassivePcContentTodo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MassivePcContentTodo = @This();

pub const sheet_name = "MassivePcContentTodo";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xde7a6c37;
pub const Sheet = excel.Typed(MassivePcContentTodo);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(12, 0);
}
