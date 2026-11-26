//! `GuidePageString`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `String`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GuidePageString = @This();

pub const sheet_name = "GuidePageString";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdebb20e3;
pub const Sheet = excel.Typed(GuidePageString);

row: excel.Row,

pub fn string(self: @This()) []const u8 {
    return self.row.stringAt(0);
}
