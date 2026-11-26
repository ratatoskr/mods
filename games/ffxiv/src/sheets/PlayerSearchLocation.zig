//! `PlayerSearchLocation`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PlayerSearchLocation = @This();

pub const sheet_name = "PlayerSearchLocation";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5eb59ccb;
pub const Sheet = excel.Typed(PlayerSearchLocation);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn sortKey(self: @This()) u8 {
    return self.row.at(u8, 4);
}
