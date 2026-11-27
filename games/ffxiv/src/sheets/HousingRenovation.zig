//! `HousingRenovation`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingRenovation = @This();

pub const sheet_name = "HousingRenovation";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xee791f98;
pub const Sheet = excel.Typed(HousingRenovation);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Territory", "Icon", "Name", "Description" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Also links to HousingIndoorTerritory which shares a 1:1 map of ids to TerritoryType
/// Links to `TerritoryType`.
pub fn territory(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 12));
}
