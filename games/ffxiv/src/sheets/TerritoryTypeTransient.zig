//! `TerritoryTypeTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `OffsetZ`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TerritoryTypeTransient = @This();

pub const sheet_name = "TerritoryTypeTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd9b2883f;
pub const Sheet = excel.Typed(TerritoryTypeTransient);

row: excel.Row,

pub fn offsetZ(self: @This()) i16 {
    return self.row.at(i16, 0);
}
