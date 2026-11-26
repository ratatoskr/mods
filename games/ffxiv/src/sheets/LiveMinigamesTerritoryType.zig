//! `LiveMinigamesTerritoryType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LiveMinigamesTerritoryType = @This();

pub const sheet_name = "LiveMinigamesTerritoryType";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xea44bd36;
pub const Sheet = excel.Typed(LiveMinigamesTerritoryType);

row: excel.Row,

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(16, 0);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(16, 1);
}
