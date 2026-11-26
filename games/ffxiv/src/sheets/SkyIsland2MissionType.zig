//! `SkyIsland2MissionType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Type`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SkyIsland2MissionType = @This();

pub const sheet_name = "SkyIsland2MissionType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd4cb81c;
pub const Sheet = excel.Typed(SkyIsland2MissionType);

row: excel.Row,

pub fn @"type"(self: @This()) bool {
    return self.row.bitAt(0, 0);
}
