//! `HWDDevLayerControl`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDDevLayerControl = @This();

pub const sheet_name = "HWDDevLayerControl";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xde74b4c4;
pub const Sheet = excel.Typed(HWDDevLayerControl);

row: excel.Row,

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 1);
}
