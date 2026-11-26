//! `PerformGuideScore`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PerformGuideScore = @This();

pub const sheet_name = "PerformGuideScore";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd85e39c0;
pub const Sheet = excel.Typed(PerformGuideScore);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 8);
}
