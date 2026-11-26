//! `SpearfishingNotebook`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `PlaceName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SpearfishingNotebook = @This();

pub const sheet_name = "SpearfishingNotebook";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0f196a4a;
pub const Sheet = excel.Typed(SpearfishingNotebook);

row: excel.Row,

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(i32, 0));
}

pub fn radius(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 6));
}

/// Links to `GatheringPointBase`.
pub fn gatheringPointBase(self: @This()) excel.Link(sheets.GatheringPointBase) {
    return .of(self.row.at(u16, 8));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn x(self: @This()) i16 {
    return self.row.at(i16, 14);
}

pub fn y(self: @This()) i16 {
    return self.row.at(i16, 16);
}

pub fn gatheringLevel(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn isShadowNode(self: @This()) bool {
    return self.row.bitAt(21, 0);
}
