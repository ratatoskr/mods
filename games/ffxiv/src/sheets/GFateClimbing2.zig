//! `GFateClimbing2`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ContentEntry`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GFateClimbing2 = @This();

pub const sheet_name = "GFateClimbing2";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(GFateClimbing2);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"ContentEntry"};

/// Links to `ContentEntry`.
pub fn contentEntry(self: @This()) excel.Link(sheets.ContentEntry) {
    return .of(self.row.at(u32, 0));
}
