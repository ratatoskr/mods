//! `XBMScoreBonus`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMScoreBonus = @This();

pub const sheet_name = "XBMScoreBonus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xed24a5df;
pub const Sheet = excel.Typed(XBMScoreBonus);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn alwaysActive(self: @This()) bool {
    return self.row.bitAt(8, 0);
}
