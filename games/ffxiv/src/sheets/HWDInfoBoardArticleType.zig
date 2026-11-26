//! `HWDInfoBoardArticleType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Type`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDInfoBoardArticleType = @This();

pub const sheet_name = "HWDInfoBoardArticleType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdebb20e3;
pub const Sheet = excel.Typed(HWDInfoBoardArticleType);

row: excel.Row,

pub fn @"type"(self: @This()) []const u8 {
    return self.row.stringAt(0);
}
