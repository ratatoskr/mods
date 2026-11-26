//! `QTE`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QTE = @This();

pub const sheet_name = "QTE";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x61035f90;
pub const Sheet = excel.Typed(QTE);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown3(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn unknown4(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn unknown5(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn unknown6(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(32, 0);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(32, 1);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(32, 2);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(32, 3);
}
