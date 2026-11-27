//! `TripleTriadRule`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TripleTriadRule = @This();

pub const sheet_name = "TripleTriadRule";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x83e50db1;
pub const Sheet = excel.Typed(TripleTriadRule);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Description", "Unknown1", "Unknown2", "Unknown4", "Unknown3", "Unknown0" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(15, 0);
}
