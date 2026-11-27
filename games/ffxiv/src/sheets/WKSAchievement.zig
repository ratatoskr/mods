//! `WKSAchievement`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Description`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSAchievement = @This();

pub const sheet_name = "WKSAchievement";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x57d9d556;
pub const Sheet = excel.Typed(WKSAchievement);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Description", "Category", "Unknown1", "RewardItem", "RewardAmount", "Unknown4" };

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `WKSAchievementRewardItem`.
pub fn rewardItem(self: @This()) excel.Link(sheets.WKSAchievementRewardItem) {
    return .of(self.row.at(u32, 8));
}

pub fn rewardAmount(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 14);
}

/// Seems to be 1 for Daily and 2 for Standard
pub fn category(self: @This()) u8 {
    return self.row.at(u8, 16);
}
