//! `GatheringPoint`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringPoint = @This();

pub const sheet_name = "GatheringPoint";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3aac3dd3;
pub const Sheet = excel.Typed(GatheringPoint);

row: excel.Row,

/// Links to `GatheringPointBase`.
pub fn gatheringPointBase(self: @This()) excel.Link(sheets.GatheringPointBase) {
    return .of(self.row.at(i32, 0));
}

pub const gathering_point_bonus_len = 2;
/// Links to `GatheringPointBonus`.
pub fn gatheringPointBonus(self: @This(), n0: usize) excel.Link(sheets.GatheringPointBonus) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 8));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 10));
}

/// Links to `GatheringSubCategory`.
pub fn gatheringSubCategory(self: @This()) excel.Link(sheets.GatheringSubCategory) {
    return .of(self.row.at(u16, 12));
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn count(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(17, 0);
}

const offsets_1 = [2]u16{ 4, 6 };
