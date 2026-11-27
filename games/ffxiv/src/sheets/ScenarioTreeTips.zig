//! `ScenarioTreeTips`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ScenarioTreeTips = @This();

pub const sheet_name = "ScenarioTreeTips";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x71371b8c;
pub const Sheet = excel.Typed(ScenarioTreeTips);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "NextTip", "Tips[0]", "RequiredLevel", "Tips[1]" };

pub const tips_len = 2;
/// Links to `ScenarioTree` or `Quest`, whichever has the row.
pub fn tips(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub fn requiredLevel(self: @This()) u16 {
    return self.row.at(u16, 8);
}

/// Links to `ScenarioTreeTips`.
pub fn nextTip(self: @This()) excel.Link(sheets.ScenarioTreeTips) {
    return .of(self.row.at(u8, 10));
}

const offsets_1 = [2]u16{ 0, 4 };
