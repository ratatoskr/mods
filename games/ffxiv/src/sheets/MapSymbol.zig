//! `MapSymbol`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MapSymbol = @This();

pub const sheet_name = "MapSymbol";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe7e370e4;
pub const Sheet = excel.Typed(MapSymbol);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Icon", "PlaceName", "DisplayNavi" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(i32, 4));
}

pub fn displayNavi(self: @This()) bool {
    return self.row.bitAt(8, 0);
}
