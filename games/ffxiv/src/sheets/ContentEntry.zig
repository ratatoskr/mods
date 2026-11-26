//! `ContentEntry`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentEntry = @This();

pub const sheet_name = "ContentEntry";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdebb20e3;
pub const Sheet = excel.Typed(ContentEntry);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}
