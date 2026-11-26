//! `XBMRandomStageEvent`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMRandomStageEvent = @This();

pub const sheet_name = "XBMRandomStageEvent";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdfb6def3;
pub const Sheet = excel.Typed(XBMRandomStageEvent);

row: excel.Row,

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 1);
}
