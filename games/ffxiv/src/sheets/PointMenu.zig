//! `PointMenu`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PointMenu = @This();

pub const sheet_name = "PointMenu";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xaafab8d8;
pub const Sheet = excel.Typed(PointMenu);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}
