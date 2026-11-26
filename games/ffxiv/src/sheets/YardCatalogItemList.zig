//! `YardCatalogItemList`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const YardCatalogItemList = @This();

pub const sheet_name = "YardCatalogItemList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x24e9963a;
pub const Sheet = excel.Typed(YardCatalogItemList);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

/// Links to `YardCatalogCategory`.
pub fn category(self: @This()) excel.Link(sheets.YardCatalogCategory) {
    return .of(self.row.at(u16, 4));
}

pub fn patch(self: @This()) u16 {
    return self.row.at(u16, 6);
}
