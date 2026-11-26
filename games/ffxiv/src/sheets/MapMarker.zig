//! `MapMarker`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MapMarker = @This();

pub const sheet_name = "MapMarker";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x39fe5d0c;
pub const Sheet = excel.Typed(MapMarker);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 0);
}

/// Links to `PlaceName`.
pub fn placeNameSubtext(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 2));
}

/// Links by `DataType`: 1 to `Map`, 2 to `Map`, 3 to `Aetheryte`, 4 to `PlaceName`.
pub fn dataKey(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn mapMarkerUnlockedBit(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn x(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn y(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn subtextOrientation(self: @This()) u8 {
    return self.row.at(u8, 12);
}

/// Links to `MapMarkerRegion`.
pub fn mapMarkerRegion(self: @This()) excel.Link(sheets.MapMarkerRegion) {
    return .of(self.row.at(u8, 13));
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn dataType(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 16);
}
