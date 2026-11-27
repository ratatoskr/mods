//! `DirectorType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DirectorType = @This();

pub const sheet_name = "DirectorType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcf4effdb;
pub const Sheet = excel.Typed(DirectorType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown3", "Unknown4", "Unknown1", "Unknown5", "Unknown2", "Unknown0" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(12, 0);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(12, 1);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(12, 2);
}
