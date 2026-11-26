//! `XBMContentStageEvent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMContentStageEvent = @This();

pub const sheet_name = "XBMContentStageEvent";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x88647d22;
pub const Sheet = excel.Typed(XBMContentStageEvent);

row: excel.Row,

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 1);
}

pub fn unknown2(self: @This()) i8 {
    return self.row.at(i8, 2);
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 3);
}
