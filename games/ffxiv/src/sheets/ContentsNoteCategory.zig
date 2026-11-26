//! `ContentsNoteCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentsNoteCategory = @This();

pub const sheet_name = "ContentsNoteCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf8c2977f;
pub const Sheet = excel.Typed(ContentsNoteCategory);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn sortKey(self: @This()) i8 {
    return self.row.at(i8, 4);
}
