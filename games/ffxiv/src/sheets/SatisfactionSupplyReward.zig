//! `SatisfactionSupplyReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SatisfactionSupplyReward = @This();

pub const sheet_name = "SatisfactionSupplyReward";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc81395f9;
pub const Sheet = excel.Typed(SatisfactionSupplyReward);

row: excel.Row,

pub const satisfaction_supply_reward_data_len = 2;
pub fn satisfactionSupplyRewardData(self: @This(), n0: usize) SatisfactionSupplyRewardDataEntry {
    std.debug.assert(n0 < 2);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const SatisfactionSupplyRewardDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn rewardCurrency(self: @This()) u16 {
        return self.row.at(u16, offsets_1[self.at[0]]);
    }

    pub fn quantityLow(self: @This()) u16 {
        return self.row.at(u16, offsets_2[self.at[0]]);
    }

    pub fn quantityMid(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }

    pub fn quantityHigh(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }
};

pub fn satisfactionLow(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn satisfactionMid(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn satisfactionHigh(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn gilLow(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn gilMid(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn gilHigh(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn bonusMultiplier(self: @This()) u8 {
    return self.row.at(u8, 28);
}

/// 0 == current cap
pub fn minLevelForSecondReward(self: @This()) u8 {
    return self.row.at(u8, 29);
}

const offsets_1 = [2]u16{ 0, 8 };
const offsets_2 = [2]u16{ 2, 10 };
const offsets_3 = [2]u16{ 4, 12 };
const offsets_4 = [2]u16{ 6, 14 };
