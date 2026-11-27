//! `CraftLeveTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CraftLeveTalk = @This();

pub const sheet_name = "CraftLeveTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x000c7d93;
pub const Sheet = excel.Typed(CraftLeveTalk);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown5", "Unknown11", "Unknown17", "Unknown23", "Unknown29", "Unknown35", "Unknown2", "Unknown8", "Unknown14", "Unknown20", "Unknown26", "Unknown32", "Unknown0", "Unknown6", "Unknown12", "Unknown18", "Unknown24", "Unknown30", "Unknown3", "Unknown9", "Unknown15", "Unknown21", "Unknown27", "Unknown33", "Unknown4", "Unknown10", "Unknown16", "Unknown22", "Unknown28", "Unknown34", "Unknown1", "Unknown7", "Unknown13", "Unknown19", "Unknown25", "Unknown31", "Talk[0]", "Talk[1]", "Talk[2]", "Talk[3]", "Talk[4]", "Talk[5]" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn unknown4(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(11, 0);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown7(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown9(self: @This()) i8 {
    return self.row.at(i8, 21);
}

pub fn unknown10(self: @This()) i8 {
    return self.row.at(i8, 22);
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(23, 0);
}

pub fn unknown12(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown13(self: @This()) i32 {
    return self.row.at(i32, 28);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown15(self: @This()) i8 {
    return self.row.at(i8, 33);
}

pub fn unknown16(self: @This()) i8 {
    return self.row.at(i8, 34);
}

pub fn unknown17(self: @This()) bool {
    return self.row.bitAt(35, 0);
}

pub fn unknown18(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown19(self: @This()) i32 {
    return self.row.at(i32, 40);
}

pub fn unknown20(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn unknown21(self: @This()) i8 {
    return self.row.at(i8, 45);
}

pub fn unknown22(self: @This()) i8 {
    return self.row.at(i8, 46);
}

pub fn unknown23(self: @This()) bool {
    return self.row.bitAt(47, 0);
}

pub fn unknown24(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown25(self: @This()) i32 {
    return self.row.at(i32, 52);
}

pub fn unknown26(self: @This()) u8 {
    return self.row.at(u8, 56);
}

pub fn unknown27(self: @This()) i8 {
    return self.row.at(i8, 57);
}

pub fn unknown28(self: @This()) i8 {
    return self.row.at(i8, 58);
}

pub fn unknown29(self: @This()) bool {
    return self.row.bitAt(59, 0);
}

pub fn unknown30(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn unknown31(self: @This()) i32 {
    return self.row.at(i32, 64);
}

pub fn unknown32(self: @This()) u8 {
    return self.row.at(u8, 68);
}

pub fn unknown33(self: @This()) i8 {
    return self.row.at(i8, 69);
}

pub fn unknown34(self: @This()) i8 {
    return self.row.at(i8, 70);
}

pub fn unknown35(self: @This()) bool {
    return self.row.bitAt(71, 0);
}

pub const talk_len = 6;
pub fn talk(self: @This(), n0: usize) []const u8 {
    return self.row.stringAt(offsets_1[n0]);
}

const offsets_1 = [6]u16{ 72, 76, 80, 84, 88, 92 };
