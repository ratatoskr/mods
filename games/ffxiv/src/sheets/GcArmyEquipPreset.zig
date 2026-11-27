//! `GcArmyEquipPreset`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyEquipPreset = @This();

pub const sheet_name = "GcArmyEquipPreset";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5a4de23a;
pub const Sheet = excel.Typed(GcArmyEquipPreset);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "MainHand", "OffHand", "Head", "Body", "Gloves", "Legs", "Feet" };

/// Links to `Item`.
pub fn mainHand(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

/// Links to `Item`.
pub fn offHand(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 4));
}

/// Links to `Item`.
pub fn head(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 8));
}

/// Links to `Item`.
pub fn body(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 12));
}

/// Links to `Item`.
pub fn gloves(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 16));
}

/// Links to `Item`.
pub fn legs(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 20));
}

/// Links to `Item`.
pub fn feet(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 24));
}
