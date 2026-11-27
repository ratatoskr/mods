//! `Knockback`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Knockback = @This();

pub const sheet_name = "Knockback";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6876beaf;
pub const Sheet = excel.Typed(Knockback);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Distance", "Speed", "Motion", "NearDistance", "Direction", "DirectionArg", "CancelMove" };

pub fn distance(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn speed(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn nearDistance(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn direction(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn directionArg(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn motion(self: @This()) bool {
    return self.row.bitAt(5, 0);
}

pub fn cancelMove(self: @This()) bool {
    return self.row.bitAt(5, 1);
}
