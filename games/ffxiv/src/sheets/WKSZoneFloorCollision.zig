//! `WKSZoneFloorCollision`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSZoneFloorCollision = @This();

pub const sheet_name = "WKSZoneFloorCollision";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(WKSZoneFloorCollision);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}
