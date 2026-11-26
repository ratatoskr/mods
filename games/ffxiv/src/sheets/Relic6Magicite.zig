//! `Relic6Magicite`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Relic6Magicite = @This();

pub const sheet_name = "Relic6Magicite";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xce73d687;
pub const Sheet = excel.Typed(Relic6Magicite);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 10);
}
