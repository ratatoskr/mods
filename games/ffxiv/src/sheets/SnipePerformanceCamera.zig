//! `SnipePerformanceCamera`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SnipePerformanceCamera = @This();

pub const sheet_name = "SnipePerformanceCamera";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x47ff2047;
pub const Sheet = excel.Typed(SnipePerformanceCamera);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown9", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown0", "Unknown7", "Unknown8", "Unknown1", "Unknown2" };

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown3(self: @This()) i16 {
    return self.row.at(i16, 6);
}

pub fn unknown4(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown5(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn unknown6(self: @This()) i16 {
    return self.row.at(i16, 12);
}

pub fn unknown7(self: @This()) i16 {
    return self.row.at(i16, 14);
}

pub fn unknown8(self: @This()) i16 {
    return self.row.at(i16, 16);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 18);
}
