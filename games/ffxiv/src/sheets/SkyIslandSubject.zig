//! `SkyIslandSubject`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SkyIslandSubject = @This();

pub const sheet_name = "SkyIslandSubject";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7686e7ec;
pub const Sheet = excel.Typed(SkyIslandSubject);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown6", "Unknown12", "Unknown0", "Unknown7", "Unknown13", "Unknown1", "Unknown8", "Unknown14", "Unknown2", "Unknown9", "Unknown15", "Unknown3", "Unknown10", "Unknown16", "Unknown4", "Unknown11", "Unknown17", "Unknown5" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 25);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 34);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 35);
}
