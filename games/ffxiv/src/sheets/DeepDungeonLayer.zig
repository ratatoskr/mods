//! `DeepDungeonLayer`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeonLayer = @This();

pub const sheet_name = "DeepDungeonLayer";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x763fdde0;
pub const Sheet = excel.Typed(DeepDungeonLayer);

row: excel.Row,

/// Links to `DeepDungeonMap5X`.
pub fn roomA(self: @This()) excel.Link(sheets.DeepDungeonMap5X) {
    return .of(self.row.at(u16, 0));
}

/// Links to `DeepDungeonMap5X`.
pub fn roomB(self: @This()) excel.Link(sheets.DeepDungeonMap5X) {
    return .of(self.row.at(u16, 2));
}

/// Links to `DeepDungeonMap5X`.
pub fn roomC(self: @This()) excel.Link(sheets.DeepDungeonMap5X) {
    return .of(self.row.at(u16, 4));
}

/// Links to `DeepDungeon`.
pub fn deepDungeon(self: @This()) excel.Link(sheets.DeepDungeon) {
    return .of(self.row.at(u8, 6));
}

pub fn floorSet(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn wepMinLv(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn armourMinLv(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(10, 0);
}
