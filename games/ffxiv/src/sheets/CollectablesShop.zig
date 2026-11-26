//! `CollectablesShop`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CollectablesShop = @This();

pub const sheet_name = "CollectablesShop";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6a066e9a;
pub const Sheet = excel.Typed(CollectablesShop);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

pub const shop_items_len = 11;
/// Links to `CollectablesShopItem`.
pub fn shopItems(self: @This(), n0: usize) excel.Link(sheets.CollectablesShopItem) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn rewardType(self: @This()) u8 {
    return self.row.at(u8, 30);
}

const offsets_1 = [11]u16{ 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28 };
