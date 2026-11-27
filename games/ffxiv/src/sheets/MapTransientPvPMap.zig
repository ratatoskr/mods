//! `MapTransientPvPMap`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MapTransientPvPMap = @This();

pub const sheet_name = "MapTransientPvPMap";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5edc18ea;
pub const Sheet = excel.Typed(MapTransientPvPMap);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}
