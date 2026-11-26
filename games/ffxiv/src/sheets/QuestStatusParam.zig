//! `QuestStatusParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestStatusParam = @This();

pub const sheet_name = "QuestStatusParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd812e07f;
pub const Sheet = excel.Typed(QuestStatusParam);

row: excel.Row,

/// Links to `Status`.
pub fn status(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(u16, 0));
}

pub fn statusParam1(self: @This()) i16 {
    return self.row.at(i16, 2);
}

pub fn statusParam2(self: @This()) u8 {
    return self.row.at(u8, 4);
}
