//! `FittingShop`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FittingShop = @This();

pub const sheet_name = "FittingShop";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x434f7f71;
pub const Sheet = excel.Typed(FittingShop);

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

pub fn unknown22(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn unknown23(self: @This()) u16 {
    return self.row.at(u16, 46);
}

pub fn unknown24(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn unknown25(self: @This()) u16 {
    return self.row.at(u16, 50);
}

pub fn unknown26(self: @This()) u16 {
    return self.row.at(u16, 52);
}

pub fn unknown27(self: @This()) u16 {
    return self.row.at(u16, 54);
}

pub fn unknown28(self: @This()) u16 {
    return self.row.at(u16, 56);
}

pub fn unknown29(self: @This()) u16 {
    return self.row.at(u16, 58);
}

pub fn unknown30(self: @This()) u16 {
    return self.row.at(u16, 60);
}

pub fn unknown31(self: @This()) u16 {
    return self.row.at(u16, 62);
}
