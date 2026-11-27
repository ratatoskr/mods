//! `FCCrestSymbol`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FCCrestSymbol = @This();

pub const sheet_name = "FCCrestSymbol";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x43bdd5b1;
pub const Sheet = excel.Typed(FCCrestSymbol);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ColorNum", "FCRight", "Unknown0" };

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn colorNum(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn fcRight(self: @This()) u8 {
    return self.row.at(u8, 3);
}
