//! `MapReplace`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MapReplace = @This();

pub const sheet_name = "MapReplace";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xe5068742;
pub const Sheet = excel.Typed(MapReplace);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown7", "Unknown8", "Unknown5", "Unknown6", "Quest", "QuestSequence", "Map", "TerritoryType", "Unknown4" };

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Map`.
pub fn map(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u16, 4));
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 6));
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn questSequence(self: @This()) u8 {
    return self.row.at(u8, 14);
}
