//! `QuestChapter`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Quest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestChapter = @This();

pub const sheet_name = "QuestChapter";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5edc18ea;
pub const Sheet = excel.Typed(QuestChapter);

row: excel.Row,

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `QuestRedoChapter`.
pub fn redo(self: @This()) excel.Link(sheets.QuestRedoChapter) {
    return .of(self.row.at(u16, 4));
}
