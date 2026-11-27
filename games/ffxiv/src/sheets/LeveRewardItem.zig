//! `LeveRewardItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LeveRewardItem = @This();

pub const sheet_name = "LeveRewardItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x00035bbe;
pub const Sheet = excel.Typed(LeveRewardItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LeveRewardItemGroup[0]", "ProbabilityPercent[0]", "LeveRewardItemGroup[1]", "ProbabilityPercent[1]", "LeveRewardItemGroup[2]", "ProbabilityPercent[2]", "LeveRewardItemGroup[3]", "ProbabilityPercent[3]", "LeveRewardItemGroup[4]", "ProbabilityPercent[4]", "LeveRewardItemGroup[5]", "ProbabilityPercent[5]", "LeveRewardItemGroup[6]", "ProbabilityPercent[6]", "LeveRewardItemGroup[7]", "ProbabilityPercent[7]" };

pub const leve_reward_item_group_len = 8;
/// Links to `LeveRewardItemGroup`.
pub fn leveRewardItemGroup(self: @This(), n0: usize) excel.Link(sheets.LeveRewardItemGroup) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub const probability_percent_len = 8;
pub fn probabilityPercent(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

const offsets_1 = [8]u16{ 0, 2, 4, 6, 8, 10, 12, 14 };
const offsets_2 = [8]u16{ 16, 17, 18, 19, 20, 21, 22, 23 };
