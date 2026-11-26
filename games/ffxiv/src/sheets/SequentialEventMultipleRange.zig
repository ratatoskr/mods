//! `SequentialEventMultipleRange`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SequentialEventMultipleRange = @This();

pub const sheet_name = "SequentialEventMultipleRange";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x4be042fe;
pub const Sheet = excel.Typed(SequentialEventMultipleRange);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(4, 0);
}
