//! `FateTokenType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Currency`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FateTokenType = @This();

pub const sheet_name = "FateTokenType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(FateTokenType);

row: excel.Row,

/// Links to `Item`.
pub fn currency(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}
