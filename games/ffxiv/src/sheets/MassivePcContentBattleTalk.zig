//! `MassivePcContentBattleTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MassivePcContentBattleTalk = @This();

pub const sheet_name = "MassivePcContentBattleTalk";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x6e7cba44;
pub const Sheet = excel.Typed(MassivePcContentBattleTalk);

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

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 16);
}
