//! `MountTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MountTransient = @This();

pub const sheet_name = "MountTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7f711762;
pub const Sheet = excel.Typed(MountTransient);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Description", "DescriptionEnhanced", "Tooltip" };

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn descriptionEnhanced(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn tooltip(self: @This()) []const u8 {
    return self.row.stringAt(8);
}
