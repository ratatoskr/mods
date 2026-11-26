//! `PreHandlerMovement`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PreHandlerMovement = @This();

pub const sheet_name = "PreHandlerMovement";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd73eab80;
pub const Sheet = excel.Typed(PreHandlerMovement);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 2);
}
