//! `AchievementHideCondition`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AchievementHideCondition = @This();

pub const sheet_name = "AchievementHideCondition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x824c4ccf;
pub const Sheet = excel.Typed(AchievementHideCondition);

row: excel.Row,

pub fn hideAchievement(self: @This()) bool {
    return self.row.bitAt(0, 0);
}

pub fn hideName(self: @This()) bool {
    return self.row.bitAt(0, 1);
}

pub fn hideConditions(self: @This()) bool {
    return self.row.bitAt(0, 2);
}
