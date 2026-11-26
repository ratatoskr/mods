//! `FittingShopCategoryItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FittingShopCategoryItem = @This();

pub const sheet_name = "FittingShopCategoryItem";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdadb0558;
pub const Sheet = excel.Typed(FittingShopCategoryItem);

row: excel.Row,

/// Links to `FittingShopItemSet` or `Item`, whichever has the row.
pub fn item(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// If not 0, the item will only appear if sent in a FittingShopUpdate packet.
pub fn displayId(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 5);
}
