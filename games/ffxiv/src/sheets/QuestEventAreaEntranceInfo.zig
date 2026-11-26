//! `QuestEventAreaEntranceInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestEventAreaEntranceInfo = @This();

pub const sheet_name = "QuestEventAreaEntranceInfo";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xaeabafd3;
pub const Sheet = excel.Typed(QuestEventAreaEntranceInfo);

row: excel.Row,

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Level`.
pub fn location(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 4));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 8);
}
