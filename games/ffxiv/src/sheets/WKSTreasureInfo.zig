//! `WKSTreasureInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSTreasureInfo = @This();

pub const sheet_name = "WKSTreasureInfo";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(WKSTreasureInfo);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}
