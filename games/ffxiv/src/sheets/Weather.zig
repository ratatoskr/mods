//! `Weather`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Weather = @This();

pub const sheet_name = "Weather";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x02cf2541;
pub const Sheet = excel.Typed(Weather);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Icon", "Name", "Description", "Unknown0", "Unknown1", "Unknown2", "Unknown3" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn unknown3(self: @This()) []const u8 {
    return self.row.stringAt(20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 24);
}
