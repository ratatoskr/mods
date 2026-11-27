//! `EurekaMagiciteItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EurekaMagiciteItem = @This();

pub const sheet_name = "EurekaMagiciteItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbc638df5;
pub const Sheet = excel.Typed(EurekaMagiciteItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EurekaMagiciteItemType", "ClassJobCategory", "Item" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `EurekaMagiciteItemType`.
pub fn eurekaMagiciteItemType(self: @This()) excel.Link(sheets.EurekaMagiciteItemType) {
    return .of(self.row.at(u8, 4));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 5));
}
