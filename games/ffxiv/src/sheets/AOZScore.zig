//! `AOZScore`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZScore = @This();

pub const sheet_name = "AOZScore";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xefee2933;
pub const Sheet = excel.Typed(AOZScore);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn score(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn isVisible(self: @This()) bool {
    return self.row.bitAt(12, 0);
}
