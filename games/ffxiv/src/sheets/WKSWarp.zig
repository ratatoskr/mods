//! `WKSWarp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSWarp = @This();

pub const sheet_name = "WKSWarp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9526fe84;
pub const Sheet = excel.Typed(WKSWarp);

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
