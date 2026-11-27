//! `Omen`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Path`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Omen = @This();

pub const sheet_name = "Omen";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd79b6c3f;
pub const Sheet = excel.Typed(Omen);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Path", "PathAlly", "Type", "RestrictYScale", "LargeScale", "Unknown0" };

pub fn path(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn pathAlly(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn restrictYScale(self: @This()) bool {
    return self.row.bitAt(10, 0);
}

pub fn largeScale(self: @This()) bool {
    return self.row.bitAt(10, 1);
}
