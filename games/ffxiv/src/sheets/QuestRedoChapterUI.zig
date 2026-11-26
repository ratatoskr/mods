//! `QuestRedoChapterUI`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Quest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestRedoChapterUI = @This();

pub const sheet_name = "QuestRedoChapterUI";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x15fc8e10;
pub const Sheet = excel.Typed(QuestRedoChapterUI);

row: excel.Row,

pub fn chapterName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn chapterPart(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn transient(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 12));
}

/// Links to `Quest`.
pub fn unknown0(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 16));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn questRedoUISmall(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn questRedoUILarge(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn questRedoUIWide(self: @This()) u32 {
    return self.row.at(u32, 28);
}

/// Links to `QuestRedoChapterUITab`.
pub fn uiTab(self: @This()) excel.Link(sheets.QuestRedoChapterUITab) {
    return .of(self.row.at(u8, 32));
}

/// Links to `QuestRedoChapterUICategory`.
pub fn category(self: @This()) excel.Link(sheets.QuestRedoChapterUICategory) {
    return .of(self.row.at(u8, 33));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 34);
}
