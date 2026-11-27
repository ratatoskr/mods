//! `PointMenuChoice`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PointMenuChoice = @This();

pub const sheet_name = "PointMenuChoice";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xcc7f3288;
pub const Sheet = excel.Typed(PointMenuChoice);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown7", "Unknown8", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown6" };

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn unknown1(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn unknown2(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn unknown3(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn unknown4(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn unknown5(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 31);
}
