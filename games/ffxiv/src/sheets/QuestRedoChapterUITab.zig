//! `QuestRedoChapterUITab`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestRedoChapterUITab = @This();

pub const sheet_name = "QuestRedoChapterUITab";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x198356e8;
pub const Sheet = excel.Typed(QuestRedoChapterUITab);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Icon1", "Icon2", "Text" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 12);
}
