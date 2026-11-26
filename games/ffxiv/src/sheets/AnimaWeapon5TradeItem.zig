//! `AnimaWeapon5TradeItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeapon5TradeItem = @This();

pub const sheet_name = "AnimaWeapon5TradeItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x40f1e693;
pub const Sheet = excel.Typed(AnimaWeapon5TradeItem);

row: excel.Row,

/// Links to `Item`.
pub fn crystalSand(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub const item_len = 8;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 36);
}

pub fn receiveQuantity(self: @This()) u8 {
    return self.row.at(u8, 37);
}

pub const quantity_len = 8;
pub fn quantity(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

/// Links to `AnimaWeapon5PatternGroup`.
pub fn category(self: @This()) excel.Link(sheets.AnimaWeapon5PatternGroup) {
    return .of(self.row.at(u8, 46));
}

pub const is_hq_len = 8;
pub fn isHQ(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_3[n0]) != 0;
}

const offsets_1 = [8]u16{ 4, 8, 12, 16, 20, 24, 28, 32 };
const offsets_2 = [8]u16{ 38, 39, 40, 41, 42, 43, 44, 45 };
const offsets_3 = [8]u16{ 47, 48, 49, 50, 51, 52, 53, 54 };
