//! `WKSAchievementDailyDefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSAchievementDailyDefine = @This();

pub const sheet_name = "WKSAchievementDailyDefine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc8a27c49;
pub const Sheet = excel.Typed(WKSAchievementDailyDefine);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SuccessPointsRequired", "RequiredQuest[0]", "RewardItem[0]", "RewardQuantity[0]", "RequiredQuest[1]", "RewardItem[1]", "RewardQuantity[1]", "RequiredQuest[2]", "RewardItem[2]", "RewardQuantity[2]", "RequiredQuest[3]", "RewardItem[3]", "RewardQuantity[3]" };

pub const required_quest_len = 4;
/// Links to `Quest`.
pub fn requiredQuest(self: @This(), n0: usize) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub const reward_item_len = 4;
/// Links to `Item`.
pub fn rewardItem(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_2[n0]));
}

pub const reward_quantity_len = 4;
pub fn rewardQuantity(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_3[n0]);
}

pub fn successPointsRequired(self: @This()) u16 {
    return self.row.at(u16, 48);
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
const offsets_2 = [4]u16{ 16, 20, 24, 28 };
const offsets_3 = [4]u16{ 32, 36, 40, 44 };
