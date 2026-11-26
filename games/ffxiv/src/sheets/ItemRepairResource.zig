//! `ItemRepairResource`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemRepairResource = @This();

pub const sheet_name = "ItemRepairResource";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(ItemRepairResource);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}
