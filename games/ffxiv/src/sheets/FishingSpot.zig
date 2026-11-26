//! `FishingSpot`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `PlaceName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FishingSpot = @This();

pub const sheet_name = "FishingSpot";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9e0d2a6c;
pub const Sheet = excel.Typed(FishingSpot);

row: excel.Row,

pub fn bigFishOnReach(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn bigFishOnEnd(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn bigFishOnRefresh(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub const item_len = 10;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 52));
}

/// Links to `PlaceName`.
pub fn placeNameMain(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 54));
}

/// Links to `PlaceName`.
pub fn placeNameSub(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 56));
}

pub fn radius(self: @This()) u16 {
    return self.row.at(u16, 58);
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 60));
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 62);
}

pub fn x(self: @This()) i16 {
    return self.row.at(i16, 64);
}

pub fn z(self: @This()) i16 {
    return self.row.at(i16, 66);
}

pub fn gatheringLevel(self: @This()) u8 {
    return self.row.at(u8, 68);
}

pub fn fishingSpotCategory(self: @This()) u8 {
    return self.row.at(u8, 69);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 70);
}

pub fn rare(self: @This()) bool {
    return self.row.bitAt(71, 0);
}

const offsets_1 = [10]u16{ 12, 16, 20, 24, 28, 32, 36, 40, 44, 48 };
