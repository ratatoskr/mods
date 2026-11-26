//! `QuestRedoIncompChapter`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Chapter`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestRedoIncompChapter = @This();

pub const sheet_name = "QuestRedoIncompChapter";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(QuestRedoIncompChapter);

row: excel.Row,

/// Links to `QuestRedoChapter`.
pub fn chapter(self: @This()) excel.Link(sheets.QuestRedoChapter) {
    return .of(self.row.at(u16, 0));
}
