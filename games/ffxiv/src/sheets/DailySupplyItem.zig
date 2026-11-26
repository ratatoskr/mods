//! `DailySupplyItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DailySupplyItem = @This();

pub const sheet_name = "DailySupplyItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5e7b2507;
pub const Sheet = excel.Typed(DailySupplyItem);

row: excel.Row,

pub const item_len = 8;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub const quantity_len = 8;
pub fn quantity(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub const recipe_level_len = 8;
pub fn recipeLevel(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_3[n0]);
}

const offsets_1 = [8]u16{ 0, 4, 8, 12, 16, 20, 24, 28 };
const offsets_2 = [8]u16{ 32, 33, 34, 35, 36, 37, 38, 39 };
const offsets_3 = [8]u16{ 40, 41, 42, 43, 44, 45, 46, 47 };
