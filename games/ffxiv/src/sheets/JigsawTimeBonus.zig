//! `JigsawTimeBonus`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const JigsawTimeBonus = @This();

pub const sheet_name = "JigsawTimeBonus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2193ebff;
pub const Sheet = excel.Typed(JigsawTimeBonus);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown8(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn unknown10(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown11(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown12(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown13(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn unknown14(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn unknown15(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub fn unknown16(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn unknown17(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn unknown18(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown19(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn unknown20(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn unknown21(self: @This()) u16 {
    return self.row.at(u16, 42);
}
