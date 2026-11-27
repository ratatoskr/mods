//! `FCChestName`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FCChestName = @This();

pub const sheet_name = "FCChestName";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9ff65ad6;
pub const Sheet = excel.Typed(FCChestName);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Unknown0" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 4);
}
