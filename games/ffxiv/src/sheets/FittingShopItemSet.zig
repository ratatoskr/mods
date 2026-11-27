//! `FittingShopItemSet`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FittingShopItemSet = @This();

pub const sheet_name = "FittingShopItemSet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5ec09e88;
pub const Sheet = excel.Typed(FittingShopItemSet);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item[0]", "Item[1]", "Item[2]", "Item[3]", "Item[4]", "Item[5]", "Name" };

pub const item_len = 6;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(24);
}

const offsets_1 = [6]u16{ 0, 4, 8, 12, 16, 20 };
