//! `RelicNoteCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RelicNoteCategory = @This();

pub const sheet_name = "RelicNoteCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf8c2977f;
pub const Sheet = excel.Typed(RelicNoteCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Text" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 4);
}
