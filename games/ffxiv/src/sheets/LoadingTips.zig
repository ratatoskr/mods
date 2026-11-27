//! `LoadingTips`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LoadingTips = @This();

pub const sheet_name = "LoadingTips";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x23b7f68c;
pub const Sheet = excel.Typed(LoadingTips);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Unknown1", "Unknown0" };

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(0, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 8);
}
