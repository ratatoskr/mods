//! `MapType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MapType = @This();

pub const sheet_name = "MapType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(MapType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"ParentMapOverride"};

/// Links to `Map`.
pub fn parentMapOverride(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u16, 0));
}
