//! `TofuPresetCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TofuPresetCategory = @This();

pub const sheet_name = "TofuPresetCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdf6e3acc;
pub const Sheet = excel.Typed(TofuPresetCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Unknown1", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(5, 0);
}
