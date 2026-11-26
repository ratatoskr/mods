//! `LFGExtensionContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LFGExtensionContent = @This();

pub const sheet_name = "LFGExtensionContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb1437bdf;
pub const Sheet = excel.Typed(LFGExtensionContent);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 8);
}
