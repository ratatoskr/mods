//! `XBMContentStageEventMap`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMContentStageEventMap = @This();

pub const sheet_name = "XBMContentStageEventMap";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x5be005ad;
pub const Sheet = excel.Typed(XBMContentStageEventMap);

row: excel.Row,

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 4);
}
