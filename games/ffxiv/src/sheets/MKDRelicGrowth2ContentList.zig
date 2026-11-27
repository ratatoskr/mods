//! `MKDRelicGrowth2ContentList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MKDRelicGrowth2ContentList = @This();

pub const sheet_name = "MKDRelicGrowth2ContentList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x198356e8;
pub const Sheet = excel.Typed(MKDRelicGrowth2ContentList);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Category", "Content", "Level", "Description" };

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links by `Category`: 0 to `ContentRoulette`, 1 to `TerritoryType`, 2 to `TerritoryType`, 3 to `TerritoryType`, 4 to `TerritoryType`, 5 to `TerritoryType`, 6 to `TerritoryType`.
pub fn content(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 8));
}

/// Links to `MKDRelicGrowth2Category`.
pub fn category(self: @This()) excel.Link(sheets.MKDRelicGrowth2Category) {
    return .of(self.row.at(u8, 12));
}
