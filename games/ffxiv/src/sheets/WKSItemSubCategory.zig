//! `WKSItemSubCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSItemSubCategory = @This();

pub const sheet_name = "WKSItemSubCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9b7b2664;
pub const Sheet = excel.Typed(WKSItemSubCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "MenuOrder" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn menuOrder(self: @This()) u16 {
    return self.row.at(u16, 4);
}
