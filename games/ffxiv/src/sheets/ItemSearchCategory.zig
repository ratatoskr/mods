//! `ItemSearchCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemSearchCategory = @This();

pub const sheet_name = "ItemSearchCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x95df38b2;
pub const Sheet = excel.Typed(ItemSearchCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Icon", "Category", "Order", "ClassJob", "Unknown0" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn category(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 9);
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(i8, 10));
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(11, 0);
}
