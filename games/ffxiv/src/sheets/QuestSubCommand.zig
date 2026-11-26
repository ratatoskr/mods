//! `QuestSubCommand`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestSubCommand = @This();

pub const sheet_name = "QuestSubCommand";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x1aa0f3da;
pub const Sheet = excel.Typed(QuestSubCommand);

row: excel.Row,

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

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 34);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 35);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 36);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 37);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 39);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub fn unknown18(self: @This()) u8 {
    return self.row.at(u8, 42);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 43);
}

pub fn unknown20(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn unknown21(self: @This()) u8 {
    return self.row.at(u8, 45);
}

pub fn unknown22(self: @This()) u8 {
    return self.row.at(u8, 46);
}

pub fn unknown23(self: @This()) u8 {
    return self.row.at(u8, 47);
}
