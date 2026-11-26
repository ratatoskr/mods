//! `Attract`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Attract = @This();

pub const sheet_name = "Attract";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdb0ddee7;
pub const Sheet = excel.Typed(Attract);

row: excel.Row,

pub fn maxDistance(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn speed(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn minRemainingDistance(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn direction(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn useDistanceBetweenHitboxes(self: @This()) bool {
    return self.row.bitAt(7, 0);
}
