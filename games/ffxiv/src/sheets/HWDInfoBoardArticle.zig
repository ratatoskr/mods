//! `HWDInfoBoardArticle`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDInfoBoardArticle = @This();

pub const sheet_name = "HWDInfoBoardArticle";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x76cb5660;
pub const Sheet = excel.Typed(HWDInfoBoardArticle);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `HWDInfoBoardArticleType`.
pub fn @"type"(self: @This()) excel.Link(sheets.HWDInfoBoardArticleType) {
    return .of(self.row.at(u8, 6));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(8, 0);
}
