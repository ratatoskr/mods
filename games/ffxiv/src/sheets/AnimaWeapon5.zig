//! `AnimaWeapon5`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AnimaWeapon5 = @This();

pub const sheet_name = "AnimaWeapon5";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe777b7a6;
pub const Sheet = excel.Typed(AnimaWeapon5);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn secondaryStatTotal(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub const parameter_len = 5;
/// Links to `AnimaWeapon5Param`.
pub fn parameter(self: @This(), n0: usize) excel.Link(sheets.AnimaWeapon5Param) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

const offsets_1 = [5]u16{ 6, 7, 8, 9, 10 };
