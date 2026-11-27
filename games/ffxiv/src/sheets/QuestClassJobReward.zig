//! `QuestClassJobReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestClassJobReward = @This();

pub const sheet_name = "QuestClassJobReward";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x9bfe038a;
pub const Sheet = excel.Typed(QuestClassJobReward);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ClassJobCategory", "RewardItem[0]", "RewardItem[1]", "RewardItem[2]", "RewardItem[3]", "RewardAmount[0]", "RewardAmount[1]", "RewardAmount[2]", "RewardAmount[3]", "RequiredItem[0]", "RequiredItem[1]", "RequiredItem[2]", "RequiredItem[3]", "Unknown8", "Unknown9", "RequiredAmount[0]", "RequiredAmount[1]", "RequiredAmount[2]", "RequiredAmount[3]", "Unknown10", "Unknown11", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown12", "Unknown13", "Unknown14", "Unknown15" };

pub const reward_item_len = 4;
/// Links to `Item`.
pub fn rewardItem(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub const required_item_len = 4;
/// Links to `Item`.
pub fn requiredItem(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_2[n0]));
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 36);
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 40));
}

pub const reward_amount_len = 4;
pub fn rewardAmount(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_3[n0]);
}

pub const required_amount_len = 4;
pub fn requiredAmount(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_4[n0]);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 49);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 50);
}

pub fn unknown0(self: @This()) bool {
    return self.row.at(u8, 51) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 52) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 53) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 54) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 55) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 56) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 57) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 58) != 0;
}

pub fn unknown12(self: @This()) bool {
    return self.row.at(u8, 59) != 0;
}

pub fn unknown13(self: @This()) bool {
    return self.row.at(u8, 60) != 0;
}

pub fn unknown14(self: @This()) bool {
    return self.row.at(u8, 61) != 0;
}

pub fn unknown15(self: @This()) bool {
    return self.row.at(u8, 62) != 0;
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
const offsets_2 = [4]u16{ 16, 20, 24, 28 };
const offsets_3 = [4]u16{ 41, 42, 43, 44 };
const offsets_4 = [4]u16{ 45, 46, 47, 48 };
