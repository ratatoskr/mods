//! `TomestonesItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TomestonesItem = @This();

pub const sheet_name = "TomestonesItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc8901190;
pub const Sheet = excel.Typed(TomestonesItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "CurrencyInventorySlot", "Tomestones" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

/// Links to `Tomestones`.
pub fn tomestones(self: @This()) excel.Link(sheets.Tomestones) {
    return .of(self.row.at(i32, 4));
}

pub fn currencyInventorySlot(self: @This()) i8 {
    return self.row.at(i8, 8);
}
