//! `McGuffinUIData`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const McGuffinUIData = @This();

pub const sheet_name = "McGuffinUIData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7e82af84;
pub const Sheet = excel.Typed(McGuffinUIData);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Order", "Icon", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 8);
}
