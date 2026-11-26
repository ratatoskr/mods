//! `HousingAethernet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingAethernet = @This();

pub const sheet_name = "HousingAethernet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x751baa92;
pub const Sheet = excel.Typed(HousingAethernet);

row: excel.Row,

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 0));
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 4));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 6));
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 8);
}
