//! `ShellFixedFromCommand`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ShellFixedFromCommand = @This();

pub const sheet_name = "ShellFixedFromCommand";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x34f26a9d;
pub const Sheet = excel.Typed(ShellFixedFromCommand);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown18", "Unknown19", "Unknown5", "Unknown6", "Unknown20", "Unknown21", "Unknown7", "Unknown8", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14", "Unknown15", "Unknown16", "Unknown17", "Unknown22[0]", "Unknown22[8]", "Unknown22[1]", "Unknown22[9]", "Unknown22[2]", "Unknown22[10]", "Unknown22[3]", "Unknown22[11]", "Unknown22[4]", "Unknown22[12]", "Unknown22[5]", "Unknown22[13]", "Unknown22[6]", "Unknown22[14]", "Unknown22[7]", "Unknown22[15]" };

pub fn unknown0(self: @This()) u64 {
    return self.row.at(u64, 0);
}

pub fn unknown1(self: @This()) u64 {
    return self.row.at(u64, 8);
}

pub fn unknown2(self: @This()) u64 {
    return self.row.at(u64, 16);
}

pub fn unknown3(self: @This()) u64 {
    return self.row.at(u64, 24);
}

pub fn unknown4(self: @This()) u64 {
    return self.row.at(u64, 32);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub const unknown22_len = 16;
pub fn unknown22(self: @This(), n0: usize) i32 {
    return self.row.at(i32, offsets_1[n0]);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 116);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 117);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 118);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 119);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 120);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 121);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 122);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 123);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 124);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 125);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(126, 0);
}

pub fn unknown19(self: @This()) bool {
    return self.row.bitAt(126, 1);
}

pub fn unknown20(self: @This()) bool {
    return self.row.bitAt(126, 2);
}

pub fn unknown21(self: @This()) bool {
    return self.row.bitAt(126, 3);
}

const offsets_1 = [16]u16{ 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112 };
