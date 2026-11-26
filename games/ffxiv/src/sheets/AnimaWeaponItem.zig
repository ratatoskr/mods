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

pub const item_len = 14;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

const offsets_1 = [14]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52 };
