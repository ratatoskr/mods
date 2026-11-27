//! `MJIRecipeMaterial`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ItemPouch`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIRecipeMaterial = @This();

pub const sheet_name = "MJIRecipeMaterial";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfaedad07;
pub const Sheet = excel.Typed(MJIRecipeMaterial);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ItemPouch", "Unknown0" };

/// Links to `MJIItemPouch`.
pub fn itemPouch(self: @This()) excel.Link(sheets.MJIItemPouch) {
    return .of(self.row.at(i32, 0));
}

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 4);
}
