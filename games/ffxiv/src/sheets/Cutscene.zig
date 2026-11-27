//! `Cutscene`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Path`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Cutscene = @This();

pub const sheet_name = "Cutscene";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xae8b8521;
pub const Sheet = excel.Typed(Cutscene);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Path", "Unknown5", "Unknown6", "Unknown7", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown8" };

pub fn path(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn unknown3(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(24, 0);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(24, 1);
}
