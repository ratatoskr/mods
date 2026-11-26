//! `MassivePcContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MassivePcContent = @This();

pub const sheet_name = "MassivePcContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcee1bba3;
pub const Sheet = excel.Typed(MassivePcContent);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown11(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 41);
}
