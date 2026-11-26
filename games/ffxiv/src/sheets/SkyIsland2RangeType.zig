//! `SkyIsland2RangeType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Type`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SkyIsland2RangeType = @This();

pub const sheet_name = "SkyIsland2RangeType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(SkyIsland2RangeType);

row: excel.Row,

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 0);
}
