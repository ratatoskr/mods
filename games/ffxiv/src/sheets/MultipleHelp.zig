//! `MultipleHelp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MultipleHelp = @This();

pub const sheet_name = "MultipleHelp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x49c8f3d3;
pub const Sheet = excel.Typed(MultipleHelp);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Unknown0", "Unknown1" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}
