//! `ExtendedQuestCounter`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ExtendedQuestCounter = @This();

pub const sheet_name = "ExtendedQuestCounter";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x33cf82e3;
pub const Sheet = excel.Typed(ExtendedQuestCounter);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Mode", "CounterValue", "QuestCustomTodoIndex", "Quest", "Unknown4" };

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

pub fn counterValue(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// 1 = 8-bit bitflag check on current value using CounterValue
/// 2 = 16-bit bitflag check on current value using CounterValue
/// 3/4 = full 32 bit current value
/// 5 = upper 8 bits of current value
/// 6 = lower 8 bits of current value
pub fn mode(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn questCustomTodoIndex(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 8);
}
