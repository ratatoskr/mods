//! `OmikujiGuidance`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OmikujiGuidance = @This();

pub const sheet_name = "OmikujiGuidance";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xed24a5df;
pub const Sheet = excel.Typed(OmikujiGuidance);

row: excel.Row,

pub fn @"type"(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn outcome(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(8, 0);
}
