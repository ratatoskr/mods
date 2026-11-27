//! `AnimaWeaponItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeaponItem = @This();

pub const sheet_name = "AnimaWeaponItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe0a5cdd0;
pub const Sheet = excel.Typed(AnimaWeaponItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item[0]", "Item[1]", "Item[2]", "Item[3]", "Item[4]", "Item[5]", "Item[6]", "Item[7]", "Item[8]", "Item[9]", "Item[10]", "Item[11]", "Item[12]", "Item[13]" };

pub const item_len = 14;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

const offsets_1 = [14]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52 };
