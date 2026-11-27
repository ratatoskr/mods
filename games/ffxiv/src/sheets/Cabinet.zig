//! `Cabinet`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Cabinet = @This();

pub const sheet_name = "Cabinet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x86748239;
pub const Sheet = excel.Typed(Cabinet);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "Order", "Category", "SubCategory" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `CabinetCategory`.
pub fn category(self: @This()) excel.Link(sheets.CabinetCategory) {
    return .of(self.row.at(u8, 6));
}

/// Links to `CabinetSubCategory`.
pub fn subCategory(self: @This()) excel.Link(sheets.CabinetSubCategory) {
    return .of(self.row.at(u8, 7));
}
