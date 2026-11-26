//! `ContentTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentTalk = @This();

pub const sheet_name = "ContentTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5eb59ccb;
pub const Sheet = excel.Typed(ContentTalk);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `ContentTalkParam`.
pub fn contentTalkParam(self: @This()) excel.Link(sheets.ContentTalkParam) {
    return .of(self.row.at(u8, 4));
}
