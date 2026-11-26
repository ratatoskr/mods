//! `CollectablesShopRefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CollectablesShopRefine = @This();

pub const sheet_name = "CollectablesShopRefine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdc23efe7;
pub const Sheet = excel.Typed(CollectablesShopRefine);

row: excel.Row,

pub fn lowCollectability(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn midCollectability(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn highCollectability(self: @This()) u16 {
    return self.row.at(u16, 4);
}
