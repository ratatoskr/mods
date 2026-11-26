//! `ContentRandomSelect`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentRandomSelect = @This();

pub const sheet_name = "ContentRandomSelect";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(ContentRandomSelect);

row: excel.Row,

/// Links to `ContentFinderCondition`.
pub fn name(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u16, 0));
}
