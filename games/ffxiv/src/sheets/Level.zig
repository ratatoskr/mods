//! `Level`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Level = @This();

pub const sheet_name = "Level";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd3d8d868;
pub const Sheet = excel.Typed(Level);

row: excel.Row,

pub fn x(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn y(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn z(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn yaw(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn radius(self: @This()) f32 {
    return self.row.at(f32, 16);
}

/// Links by `Type`: 8 to `ENpcBase`, 9 to `BNpcBase`, 12 to `Aetheryte`, 14 to `GatheringPoint`, 45 to `EObj`.
pub fn object(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// Links to `TripleTriad`, `Adventure`, `Opening` or `Quest`, whichever has the row.
pub fn eventId(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// Links to `Map`.
pub fn map(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u16, 28));
}

/// Links to `TerritoryType`.
pub fn territory(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 30));
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 32);
}
