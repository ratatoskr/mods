//! `WKSTreasure`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSTreasure = @This();

pub const sheet_name = "WKSTreasure";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbc638df5;
pub const Sheet = excel.Typed(WKSTreasure);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Unknown2", "Unknown0" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 5);
}
