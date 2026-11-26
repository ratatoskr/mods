//! `QuestBattleResident`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestBattleResident = @This();

pub const sheet_name = "QuestBattleResident";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(QuestBattleResident);

row: excel.Row,

/// Links to `ContentFinderCondition`.
pub fn soloDuty(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u16, 0));
}
