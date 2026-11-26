//! `ItemRetainerLevelUp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemRetainerLevelUp = @This();

pub const sheet_name = "ItemRetainerLevelUp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5edc18ea;
pub const Sheet = excel.Typed(ItemRetainerLevelUp);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub fn retainerLevel(self: @This()) u16 {
    return self.row.at(u16, 4);
}
