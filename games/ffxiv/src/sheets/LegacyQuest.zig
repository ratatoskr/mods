//! `LegacyQuest`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LegacyQuest = @This();

pub const sheet_name = "LegacyQuest";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe0c8dfe4;
pub const Sheet = excel.Typed(LegacyQuest);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LegacyQuestID", "Text", "String", "SortKey", "Genre" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn string(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `JournalGenre`.
pub fn genre(self: @This()) excel.Link(sheets.JournalGenre) {
    return .of(self.row.at(u32, 8));
}

pub fn legacyQuestID(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 14);
}
