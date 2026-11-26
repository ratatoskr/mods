//! `WeeklyBingoRewardData`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `RewardItem1`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeeklyBingoRewardData = @This();

pub const sheet_name = "WeeklyBingoRewardData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x02b099a0;
pub const Sheet = excel.Typed(WeeklyBingoRewardData);

row: excel.Row,

pub fn rewardItem1(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links by `RewardType2`: 1 to `Item`, 2 to `Tomestones`.
pub fn rewardItem2(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links by `RewardType3`: 1 to `Item`, 2 to `Tomestones`.
pub fn rewardItem3(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn rewardQuantity1(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn rewardQuantity2(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn rewardQuantity3(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn rewardType1(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn rewardType2(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn rewardType3(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn rewardHq2(self: @This()) bool {
    return self.row.at(u8, 22) != 0;
}

pub fn rewardHq3(self: @This()) bool {
    return self.row.at(u8, 23) != 0;
}

pub fn rewardHq1(self: @This()) bool {
    return self.row.bitAt(24, 0);
}
