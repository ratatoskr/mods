//! `Festival`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Festival = @This();

pub const sheet_name = "Festival";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x326ecf1b;
pub const Sheet = excel.Typed(Festival);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn isAllSaintsWake(self: @This()) u8 {
    return self.row.at(u8, 4);
}

/// Links to `WeatherRate`.
pub fn weatherRate(self: @This()) excel.Link(sheets.WeatherRate) {
    return .of(self.row.at(u8, 5));
}
