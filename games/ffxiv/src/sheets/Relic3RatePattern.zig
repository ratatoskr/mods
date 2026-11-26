//! `Relic3RatePattern`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Relic3RatePattern = @This();

pub const sheet_name = "Relic3RatePattern";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9b330d8a;
pub const Sheet = excel.Typed(Relic3RatePattern);

row: excel.Row,

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 0);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 1);
}

pub fn unknown2(self: @This()) i8 {
    return self.row.at(i8, 2);
}
