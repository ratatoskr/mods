//! `Marker`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Marker = @This();

pub const sheet_name = "Marker";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x30ebf383;
pub const Sheet = excel.Typed(Marker);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn sortOrder(self: @This()) u8 {
    return self.row.at(u8, 8);
}
