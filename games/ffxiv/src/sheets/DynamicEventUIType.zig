//! `DynamicEventUIType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DynamicEventUIType = @This();

pub const sheet_name = "DynamicEventUIType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb5f86efe;
pub const Sheet = excel.Typed(DynamicEventUIType);

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

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown11(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown12(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown13(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub fn unknown14(self: @This()) u32 {
    return self.row.at(u32, 56);
}

pub fn unknown15(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn unknown16(self: @This()) u32 {
    return self.row.at(u32, 64);
}

pub fn unknown17(self: @This()) u32 {
    return self.row.at(u32, 68);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(72, 0);
}
