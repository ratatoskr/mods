//! `QuestCustomTodo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestCustomTodo = @This();

pub const sheet_name = "QuestCustomTodo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x24953396;
pub const Sheet = excel.Typed(QuestCustomTodo);

row: excel.Row,

pub const index_len = 7;
/// 65535 if unused. Index in the CustomTodoManager.
pub fn index(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_1[n0]);
}

pub const max_value_len = 7;
pub fn maxValue(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

/// Which array to choose in the CustomTodoManager and how big the values can be. 0 = Byte, 1 = UShort
pub fn dataType(self: @This()) u8 {
    return self.row.at(u8, 28);
}

const offsets_1 = [7]u16{ 0, 2, 4, 6, 8, 10, 12 };
const offsets_2 = [7]u16{ 14, 16, 18, 20, 22, 24, 26 };
