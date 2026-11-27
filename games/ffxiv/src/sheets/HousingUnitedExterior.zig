//! `HousingUnitedExterior`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingUnitedExterior = @This();

pub const sheet_name = "HousingUnitedExterior";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x88a791a7;
pub const Sheet = excel.Typed(HousingUnitedExterior);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "PlotSize", "Roof", "Walls", "Windows", "Door", "OptionalRoof", "OptionalWall", "OptionalSignboard", "Fence" };

/// Links to `HousingExterior`.
pub fn roof(self: @This()) excel.Link(sheets.HousingExterior) {
    return .of(self.row.at(u32, 0));
}

/// Links to `HousingExterior`.
pub fn walls(self: @This()) excel.Link(sheets.HousingExterior) {
    return .of(self.row.at(u32, 4));
}

/// Links to `HousingExterior`.
pub fn windows(self: @This()) excel.Link(sheets.HousingExterior) {
    return .of(self.row.at(u32, 8));
}

/// Links to `HousingExterior`.
pub fn door(self: @This()) excel.Link(sheets.HousingExterior) {
    return .of(self.row.at(u32, 12));
}

/// Links to `HousingExterior`.
pub fn optionalRoof(self: @This()) excel.Link(sheets.HousingExterior) {
    return .of(self.row.at(u32, 16));
}

/// Links to `HousingExterior`.
pub fn optionalWall(self: @This()) excel.Link(sheets.HousingExterior) {
    return .of(self.row.at(u32, 20));
}

/// Links to `HousingExterior`.
pub fn optionalSignboard(self: @This()) excel.Link(sheets.HousingExterior) {
    return .of(self.row.at(u32, 24));
}

/// Links to `HousingExterior`.
pub fn fence(self: @This()) excel.Link(sheets.HousingExterior) {
    return .of(self.row.at(u32, 28));
}

pub fn plotSize(self: @This()) u8 {
    return self.row.at(u8, 32);
}
