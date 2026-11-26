//! `Map`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `PlaceName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Map = @This();

pub const sheet_name = "Map";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1290e448;
pub const Sheet = excel.Typed(Map);

row: excel.Row,

pub fn id(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn discoveryFlag(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn mapMarkerRange(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn sizeFactor(self: @This()) u16 {
    return self.row.at(u16, 10);
}

/// Links to `PlaceName`.
pub fn placeNameRegion(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 12));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 14));
}

/// Links to `PlaceName`.
pub fn placeNameSub(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 16));
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 18));
}

pub fn offsetX(self: @This()) i16 {
    return self.row.at(i16, 20);
}

pub fn offsetY(self: @This()) i16 {
    return self.row.at(i16, 22);
}

pub fn discoveryIndex(self: @This()) i16 {
    return self.row.at(i16, 24);
}

/// Links to `MapCondition`.
pub fn mapCondition(self: @This()) excel.Link(sheets.MapCondition) {
    return .of(self.row.at(u8, 26));
}

pub fn priorityCategoryUI(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn priorityUI(self: @This()) u8 {
    return self.row.at(u8, 28);
}

/// Links to `MapType`.
pub fn mapType(self: @This()) excel.Link(sheets.MapType) {
    return .of(self.row.at(u8, 29));
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 30);
}

/// Links to `MapReplace`.
pub fn mapReplace(self: @This()) excel.Link(sheets.MapReplace) {
    return .of(self.row.at(u8, 31));
}

pub fn mapIndex(self: @This()) i8 {
    return self.row.at(i8, 32);
}

pub fn discoveryArrayByte(self: @This()) bool {
    return self.row.bitAt(33, 0);
}

pub fn isEvent(self: @This()) bool {
    return self.row.bitAt(33, 1);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(33, 2);
}
