//! `QuestRedoChapterUICategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Expac`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestRedoChapterUICategory = @This();

pub const sheet_name = "QuestRedoChapterUICategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5eb59ccb;
pub const Sheet = excel.Typed(QuestRedoChapterUICategory);

row: excel.Row,

pub fn expac(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 4);
}
