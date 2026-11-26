//! `MiniGameTurnBreakEnemy`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MiniGameTurnBreakEnemy = @This();

pub const sheet_name = "MiniGameTurnBreakEnemy";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8267f7fa;
pub const Sheet = excel.Typed(MiniGameTurnBreakEnemy);

row: excel.Row,

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(6, 0);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(6, 1);
}

pub fn unknown5(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(14, 0);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(14, 1);
}

pub fn unknown10(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(22, 0);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(22, 1);
}

pub fn unknown15(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(30, 0);
}

pub fn unknown19(self: @This()) bool {
    return self.row.bitAt(30, 1);
}

pub fn unknown20(self: @This()) i32 {
    return self.row.at(i32, 32);
}

pub fn unknown21(self: @This()) i32 {
    return self.row.at(i32, 36);
}

pub fn unknown22(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn unknown23(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub fn unknown24(self: @This()) u8 {
    return self.row.at(u8, 42);
}

pub fn unknown25(self: @This()) u8 {
    return self.row.at(u8, 43);
}

pub fn unknown26(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn unknown27(self: @This()) u8 {
    return self.row.at(u8, 45);
}

pub fn unknown28(self: @This()) u8 {
    return self.row.at(u8, 46);
}

pub fn unknown29(self: @This()) u8 {
    return self.row.at(u8, 47);
}

pub fn unknown30(self: @This()) u8 {
    return self.row.at(u8, 48);
}

pub fn unknown31(self: @This()) u8 {
    return self.row.at(u8, 49);
}

pub fn unknown32(self: @This()) u8 {
    return self.row.at(u8, 50);
}

pub fn unknown33(self: @This()) u8 {
    return self.row.at(u8, 51);
}

pub fn unknown34(self: @This()) bool {
    return self.row.bitAt(52, 0);
}
