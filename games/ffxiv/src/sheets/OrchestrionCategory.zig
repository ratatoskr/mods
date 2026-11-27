//! `OrchestrionCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OrchestrionCategory = @This();

pub const sheet_name = "OrchestrionCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x005990e4;
pub const Sheet = excel.Typed(OrchestrionCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "HideOrder", "Icon", "Order", "Unknown0" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn hideOrder(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(10, 0);
}
