//! `MJIProgress`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIProgress = @This();

pub const sheet_name = "MJIProgress";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe3dea9d5;
pub const Sheet = excel.Typed(MJIProgress);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Vision", "Objective", "PreviousObjective", "Unknown3", "Unknown8", "Unknown13", "Unknown4", "Unknown9", "Unknown14", "Unknown5", "Unknown10", "Unknown15", "Unknown6", "Unknown11", "Unknown16", "Unknown7", "Unknown12", "Unknown17", "Unknown18", "Unknown1", "Unknown2", "Unknown0", "Unknown19" };

pub fn vision(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn objective(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn previousObjective(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown1(self: @This()) i16 {
    return self.row.at(i16, 14);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 16);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 25);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown18(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 34);
}
