//! `GFateClimbing2TotemType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `PublicContentTextData`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GFateClimbing2TotemType = @This();

pub const sheet_name = "GFateClimbing2TotemType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(GFateClimbing2TotemType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"PublicContentTextData"};

/// Links to `PublicContentTextData`.
pub fn publicContentTextData(self: @This()) excel.Link(sheets.PublicContentTextData) {
    return .of(self.row.at(u32, 0));
}
