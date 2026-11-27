//! `CompleteJournalCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompleteJournalCategory = @This();

pub const sheet_name = "CompleteJournalCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x976040dd;
pub const Sheet = excel.Typed(CompleteJournalCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "FirstQuest", "LastQuest", "Unknown0" };

/// Links to `CompleteJournal`.
pub fn firstQuest(self: @This()) excel.Link(sheets.CompleteJournal) {
    return .of(self.row.at(u32, 0));
}

/// Links to `CompleteJournal`.
pub fn lastQuest(self: @This()) excel.Link(sheets.CompleteJournal) {
    return .of(self.row.at(u32, 4));
}

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 8);
}
