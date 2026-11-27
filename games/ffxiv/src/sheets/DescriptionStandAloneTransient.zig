//! `DescriptionStandAloneTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DescriptionStandAloneTransient = @This();

pub const sheet_name = "DescriptionStandAloneTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x11a44a12;
pub const Sheet = excel.Typed(DescriptionStandAloneTransient);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Name", "Unknown1" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}
