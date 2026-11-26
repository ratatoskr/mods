//! `GuideTitle`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Title`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GuideTitle = @This();

pub const sheet_name = "GuideTitle";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9db0e48f;
pub const Sheet = excel.Typed(GuideTitle);

row: excel.Row,

pub fn title(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(4);
}
