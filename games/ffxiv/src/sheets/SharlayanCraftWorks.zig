//! `SharlayanCraftWorks`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SharlayanCraftWorks = @This();

pub const sheet_name = "SharlayanCraftWorks";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x92b51979;
pub const Sheet = excel.Typed(SharlayanCraftWorks);

row: excel.Row,

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Level`.
pub fn questgiver(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 4));
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}
