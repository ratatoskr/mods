//! `GuildleveAssignmentTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GuildleveAssignmentTalk = @This();

pub const sheet_name = "GuildleveAssignmentTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xed64467f;
pub const Sheet = excel.Typed(GuildleveAssignmentTalk);

row: excel.Row,

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

pub const talk_len = 8;
pub fn talk(self: @This(), n0: usize) []const u8 {
    return self.row.stringAt(offsets_1[n0]);
}

const offsets_1 = [8]u16{ 60, 64, 68, 72, 76, 80, 84, 88 };
