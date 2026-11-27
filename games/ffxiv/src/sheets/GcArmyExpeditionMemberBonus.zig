//! `GcArmyExpeditionMemberBonus`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyExpeditionMemberBonus = @This();

pub const sheet_name = "GcArmyExpeditionMemberBonus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xde74b4c4;
pub const Sheet = excel.Typed(GcArmyExpeditionMemberBonus);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Race", "ClassJob" };

/// Links to `Race`.
pub fn race(self: @This()) excel.Link(sheets.Race) {
    return .of(self.row.at(u8, 0));
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 1));
}
