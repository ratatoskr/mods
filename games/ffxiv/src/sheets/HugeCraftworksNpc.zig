//! `HugeCraftworksNpc`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `EventNpc`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HugeCraftworksNpc = @This();

pub const sheet_name = "HugeCraftworksNpc";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc1d2986a;
pub const Sheet = excel.Typed(HugeCraftworksNpc);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EventNpc", "ClassJobCategory", "HugeCraftworksTurnInParam[0].RequestedItem", "HugeCraftworksTurnInParam[1].RequestedItem", "HugeCraftworksTurnInParam[2].RequestedItem", "HugeCraftworksTurnInParam[3].RequestedItem", "HugeCraftworksTurnInParam[4].RequestedItem", "HugeCraftworksTurnInParam[5].RequestedItem", "HugeCraftworksTurnInParam[0].RequestedQuantity", "HugeCraftworksTurnInParam[1].RequestedQuantity", "HugeCraftworksTurnInParam[2].RequestedQuantity", "HugeCraftworksTurnInParam[3].RequestedQuantity", "HugeCraftworksTurnInParam[4].RequestedQuantity", "HugeCraftworksTurnInParam[5].RequestedQuantity", "HugeCraftworksTurnInParam[0].Unknown6", "HugeCraftworksTurnInParam[1].Unknown6", "HugeCraftworksTurnInParam[2].Unknown6", "HugeCraftworksTurnInParam[3].Unknown6", "HugeCraftworksTurnInParam[4].Unknown6", "HugeCraftworksTurnInParam[5].Unknown6", "HugeCraftworksTurnInParam[0].Unknown1", "HugeCraftworksTurnInParam[1].Unknown1", "HugeCraftworksTurnInParam[2].Unknown1", "HugeCraftworksTurnInParam[3].Unknown1", "HugeCraftworksTurnInParam[4].Unknown1", "HugeCraftworksTurnInParam[5].Unknown1", "HugeCraftworksTurnInParam[0].Unknown2", "HugeCraftworksTurnInParam[1].Unknown2", "HugeCraftworksTurnInParam[2].Unknown2", "HugeCraftworksTurnInParam[3].Unknown2", "HugeCraftworksTurnInParam[4].Unknown2", "HugeCraftworksTurnInParam[5].Unknown2", "HugeCraftworksTurnInParam[0].Unknown3", "HugeCraftworksTurnInParam[1].Unknown3", "HugeCraftworksTurnInParam[2].Unknown3", "HugeCraftworksTurnInParam[3].Unknown3", "HugeCraftworksTurnInParam[4].Unknown3", "HugeCraftworksTurnInParam[5].Unknown3", "HugeCraftworksTurnInParam[0].Unknown0", "HugeCraftworksTurnInParam[1].Unknown0", "HugeCraftworksTurnInParam[2].Unknown0", "HugeCraftworksTurnInParam[3].Unknown0", "HugeCraftworksTurnInParam[4].Unknown0", "HugeCraftworksTurnInParam[5].Unknown0", "HugeCraftworksTurnInParam[0].Unknown4", "HugeCraftworksTurnInParam[1].Unknown4", "HugeCraftworksTurnInParam[2].Unknown4", "HugeCraftworksTurnInParam[3].Unknown4", "HugeCraftworksTurnInParam[4].Unknown4", "HugeCraftworksTurnInParam[5].Unknown4", "HugeCraftworksTurnInParam[0].Unknown5", "HugeCraftworksTurnInParam[1].Unknown5", "HugeCraftworksTurnInParam[2].Unknown5", "HugeCraftworksTurnInParam[3].Unknown5", "HugeCraftworksTurnInParam[4].Unknown5", "HugeCraftworksTurnInParam[5].Unknown5", "HugeCraftworksRewardParam[0].RewardItem[0]", "HugeCraftworksRewardParam[1].RewardItem[0]", "HugeCraftworksRewardParam[2].RewardItem[0]", "HugeCraftworksRewardParam[3].RewardItem[0]", "HugeCraftworksRewardParam[4].RewardItem[0]", "HugeCraftworksRewardParam[5].RewardItem[0]", "HugeCraftworksRewardParam[0].RewardHQ[0]", "HugeCraftworksRewardParam[1].RewardHQ[0]", "HugeCraftworksRewardParam[2].RewardHQ[0]", "HugeCraftworksRewardParam[3].RewardHQ[0]", "HugeCraftworksRewardParam[4].RewardHQ[0]", "HugeCraftworksRewardParam[5].RewardHQ[0]", "HugeCraftworksRewardParam[0].RewardQuantity[0]", "HugeCraftworksRewardParam[1].RewardQuantity[0]", "HugeCraftworksRewardParam[2].RewardQuantity[0]", "HugeCraftworksRewardParam[3].RewardQuantity[0]", "HugeCraftworksRewardParam[4].RewardQuantity[0]", "HugeCraftworksRewardParam[5].RewardQuantity[0]", "HugeCraftworksRewardParam[0].RewardItem[1]", "HugeCraftworksRewardParam[1].RewardItem[1]", "HugeCraftworksRewardParam[2].RewardItem[1]", "HugeCraftworksRewardParam[3].RewardItem[1]", "HugeCraftworksRewardParam[4].RewardItem[1]", "HugeCraftworksRewardParam[5].RewardItem[1]", "HugeCraftworksRewardParam[0].RewardHQ[1]", "HugeCraftworksRewardParam[1].RewardHQ[1]", "HugeCraftworksRewardParam[2].RewardHQ[1]", "HugeCraftworksRewardParam[3].RewardHQ[1]", "HugeCraftworksRewardParam[4].RewardHQ[1]", "HugeCraftworksRewardParam[5].RewardHQ[1]", "HugeCraftworksRewardParam[0].RewardQuantity[1]", "HugeCraftworksRewardParam[1].RewardQuantity[1]", "HugeCraftworksRewardParam[2].RewardQuantity[1]", "HugeCraftworksRewardParam[3].RewardQuantity[1]", "HugeCraftworksRewardParam[4].RewardQuantity[1]", "HugeCraftworksRewardParam[5].RewardQuantity[1]", "Transient" };

pub const huge_craftworks_turn_in_param_len = 6;
pub fn hugeCraftworksTurnInParam(self: @This(), n0: usize) HugeCraftworksTurnInParamEntry {
    std.debug.assert(n0 < 6);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const HugeCraftworksTurnInParamEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Item`.
    pub fn requestedItem(self: @This()) excel.Link(sheets.Item) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    pub fn unknown0(self: @This()) u16 {
        return self.row.at(u16, offsets_2[self.at[0]]);
    }

    pub fn requestedQuantity(self: @This()) u8 {
        return self.row.at(u8, offsets_3[self.at[0]]);
    }

    pub fn unknown1(self: @This()) u8 {
        return self.row.at(u8, offsets_4[self.at[0]]);
    }

    pub fn unknown2(self: @This()) u8 {
        return self.row.at(u8, offsets_5[self.at[0]]);
    }

    pub fn unknown3(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn unknown4(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }

    pub fn unknown5(self: @This()) u8 {
        return self.row.at(u8, offsets_8[self.at[0]]);
    }

    pub fn unknown6(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_9[self.at[0]] >> 3), @intCast(offsets_9[self.at[0]] & 7));
    }
};

pub const huge_craftworks_reward_param_len = 6;
pub fn hugeCraftworksRewardParam(self: @This(), n0: usize) HugeCraftworksRewardParamEntry {
    std.debug.assert(n0 < 6);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const HugeCraftworksRewardParamEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub const reward_item_len = 2;
    /// Links to `Item`.
    pub fn rewardItem(self: @This(), n1: usize) excel.Link(sheets.Item) {
        return .of(self.row.at(u32, offsets_10[self.at[0]][n1]));
    }

    pub const reward_quantity_len = 2;
    pub fn rewardQuantity(self: @This(), n1: usize) u8 {
        return self.row.at(u8, offsets_11[self.at[0]][n1]);
    }

    pub const reward_hq_len = 2;
    pub fn rewardHQ(self: @This(), n1: usize) bool {
        return self.row.at(u8, offsets_12[self.at[0]][n1]) != 0;
    }
};

pub fn transient(self: @This()) []const u8 {
    return self.row.stringAt(168);
}

/// Links to `ENpcResident`.
pub fn eventNpc(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(u32, 172));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u16, 176));
}

const offsets_1 = [6]u16{ 0, 16, 32, 48, 64, 80 };
const offsets_2 = [6]u16{ 4, 20, 36, 52, 68, 84 };
const offsets_3 = [6]u16{ 6, 22, 38, 54, 70, 86 };
const offsets_4 = [6]u16{ 7, 23, 39, 55, 71, 87 };
const offsets_5 = [6]u16{ 8, 24, 40, 56, 72, 88 };
const offsets_6 = [6]u16{ 9, 25, 41, 57, 73, 89 };
const offsets_7 = [6]u16{ 10, 26, 42, 58, 74, 90 };
const offsets_8 = [6]u16{ 11, 27, 43, 59, 75, 91 };
const offsets_9 = [6]u32{ 96, 224, 352, 480, 608, 736 };
const offsets_10 = [6][2]u16{ .{ 96, 100 }, .{ 108, 112 }, .{ 120, 124 }, .{ 132, 136 }, .{ 144, 148 }, .{ 156, 160 } };
const offsets_11 = [6][2]u16{ .{ 104, 105 }, .{ 116, 117 }, .{ 128, 129 }, .{ 140, 141 }, .{ 152, 153 }, .{ 164, 165 } };
const offsets_12 = [6][2]u16{ .{ 106, 107 }, .{ 118, 119 }, .{ 130, 131 }, .{ 142, 143 }, .{ 154, 155 }, .{ 166, 167 } };
