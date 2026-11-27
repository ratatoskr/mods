//! `WKSPlanetSelect`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSPlanetSelect = @This();

pub const sheet_name = "WKSPlanetSelect";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8d217a3e;
pub const Sheet = excel.Typed(WKSPlanetSelect);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown4", "Name", "PlanetImage", "Backdrop", "Blurb" };

pub fn blurb(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `PlaceName`.
pub fn name(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u32, 4));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn planetImage(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn backdrop(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 16);
}
