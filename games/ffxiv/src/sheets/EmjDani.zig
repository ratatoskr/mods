//! `EmjDani`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EmjDani = @This();

pub const sheet_name = "EmjDani";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf3fb0152;
pub const Sheet = excel.Typed(EmjDani);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Icon", "Unknown0", "Unknown1", "Unknown10", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown3(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn unknown4(self: @This()) i16 {
    return self.row.at(i16, 12);
}

pub fn unknown5(self: @This()) i16 {
    return self.row.at(i16, 14);
}

pub fn unknown6(self: @This()) i16 {
    return self.row.at(i16, 16);
}

pub fn unknown7(self: @This()) i16 {
    return self.row.at(i16, 18);
}

pub fn unknown8(self: @This()) i16 {
    return self.row.at(i16, 20);
}

pub fn unknown9(self: @This()) i16 {
    return self.row.at(i16, 22);
}

pub fn unknown10(self: @This()) bool {
    return self.row.bitAt(24, 0);
}
