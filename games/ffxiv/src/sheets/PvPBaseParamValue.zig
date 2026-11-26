//! `PvPBaseParamValue`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPBaseParamValue = @This();

pub const sheet_name = "PvPBaseParamValue";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x96a22aea;
pub const Sheet = excel.Typed(PvPBaseParamValue);

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
