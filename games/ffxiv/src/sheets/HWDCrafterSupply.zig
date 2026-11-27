//! `HWDCrafterSupply`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDCrafterSupply = @This();

pub const sheet_name = "HWDCrafterSupply";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa04b4cc9;
pub const Sheet = excel.Typed(HWDCrafterSupply);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "HWDCrafterSupplyParams[0].ItemTradeIn", "HWDCrafterSupplyParams[1].ItemTradeIn", "HWDCrafterSupplyParams[2].ItemTradeIn", "HWDCrafterSupplyParams[3].ItemTradeIn", "HWDCrafterSupplyParams[4].ItemTradeIn", "HWDCrafterSupplyParams[5].ItemTradeIn", "HWDCrafterSupplyParams[6].ItemTradeIn", "HWDCrafterSupplyParams[7].ItemTradeIn", "HWDCrafterSupplyParams[8].ItemTradeIn", "HWDCrafterSupplyParams[9].ItemTradeIn", "HWDCrafterSupplyParams[10].ItemTradeIn", "HWDCrafterSupplyParams[11].ItemTradeIn", "HWDCrafterSupplyParams[12].ItemTradeIn", "HWDCrafterSupplyParams[13].ItemTradeIn", "HWDCrafterSupplyParams[14].ItemTradeIn", "HWDCrafterSupplyParams[15].ItemTradeIn", "HWDCrafterSupplyParams[16].ItemTradeIn", "HWDCrafterSupplyParams[17].ItemTradeIn", "HWDCrafterSupplyParams[18].ItemTradeIn", "HWDCrafterSupplyParams[19].ItemTradeIn", "HWDCrafterSupplyParams[20].ItemTradeIn", "HWDCrafterSupplyParams[21].ItemTradeIn", "HWDCrafterSupplyParams[22].ItemTradeIn", "HWDCrafterSupplyParams[0].Level", "HWDCrafterSupplyParams[1].Level", "HWDCrafterSupplyParams[2].Level", "HWDCrafterSupplyParams[3].Level", "HWDCrafterSupplyParams[4].Level", "HWDCrafterSupplyParams[5].Level", "HWDCrafterSupplyParams[6].Level", "HWDCrafterSupplyParams[7].Level", "HWDCrafterSupplyParams[8].Level", "HWDCrafterSupplyParams[9].Level", "HWDCrafterSupplyParams[10].Level", "HWDCrafterSupplyParams[11].Level", "HWDCrafterSupplyParams[12].Level", "HWDCrafterSupplyParams[13].Level", "HWDCrafterSupplyParams[14].Level", "HWDCrafterSupplyParams[15].Level", "HWDCrafterSupplyParams[16].Level", "HWDCrafterSupplyParams[17].Level", "HWDCrafterSupplyParams[18].Level", "HWDCrafterSupplyParams[19].Level", "HWDCrafterSupplyParams[20].Level", "HWDCrafterSupplyParams[21].Level", "HWDCrafterSupplyParams[22].Level", "HWDCrafterSupplyParams[0].LevelMax", "HWDCrafterSupplyParams[1].LevelMax", "HWDCrafterSupplyParams[2].LevelMax", "HWDCrafterSupplyParams[3].LevelMax", "HWDCrafterSupplyParams[4].LevelMax", "HWDCrafterSupplyParams[5].LevelMax", "HWDCrafterSupplyParams[6].LevelMax", "HWDCrafterSupplyParams[7].LevelMax", "HWDCrafterSupplyParams[8].LevelMax", "HWDCrafterSupplyParams[9].LevelMax", "HWDCrafterSupplyParams[10].LevelMax", "HWDCrafterSupplyParams[11].LevelMax", "HWDCrafterSupplyParams[12].LevelMax", "HWDCrafterSupplyParams[13].LevelMax", "HWDCrafterSupplyParams[14].LevelMax", "HWDCrafterSupplyParams[15].LevelMax", "HWDCrafterSupplyParams[16].LevelMax", "HWDCrafterSupplyParams[17].LevelMax", "HWDCrafterSupplyParams[18].LevelMax", "HWDCrafterSupplyParams[19].LevelMax", "HWDCrafterSupplyParams[20].LevelMax", "HWDCrafterSupplyParams[21].LevelMax", "HWDCrafterSupplyParams[22].LevelMax", "HWDCrafterSupplyParams[0].Unknown0", "HWDCrafterSupplyParams[1].Unknown0", "HWDCrafterSupplyParams[2].Unknown0", "HWDCrafterSupplyParams[3].Unknown0", "HWDCrafterSupplyParams[4].Unknown0", "HWDCrafterSupplyParams[5].Unknown0", "HWDCrafterSupplyParams[6].Unknown0", "HWDCrafterSupplyParams[7].Unknown0", "HWDCrafterSupplyParams[8].Unknown0", "HWDCrafterSupplyParams[9].Unknown0", "HWDCrafterSupplyParams[10].Unknown0", "HWDCrafterSupplyParams[11].Unknown0", "HWDCrafterSupplyParams[12].Unknown0", "HWDCrafterSupplyParams[13].Unknown0", "HWDCrafterSupplyParams[14].Unknown0", "HWDCrafterSupplyParams[15].Unknown0", "HWDCrafterSupplyParams[16].Unknown0", "HWDCrafterSupplyParams[17].Unknown0", "HWDCrafterSupplyParams[18].Unknown0", "HWDCrafterSupplyParams[19].Unknown0", "HWDCrafterSupplyParams[20].Unknown0", "HWDCrafterSupplyParams[21].Unknown0", "HWDCrafterSupplyParams[22].Unknown0", "HWDCrafterSupplyParams[0].BaseCollectableRating", "HWDCrafterSupplyParams[1].BaseCollectableRating", "HWDCrafterSupplyParams[2].BaseCollectableRating", "HWDCrafterSupplyParams[3].BaseCollectableRating", "HWDCrafterSupplyParams[4].BaseCollectableRating", "HWDCrafterSupplyParams[5].BaseCollectableRating", "HWDCrafterSupplyParams[6].BaseCollectableRating", "HWDCrafterSupplyParams[7].BaseCollectableRating", "HWDCrafterSupplyParams[8].BaseCollectableRating", "HWDCrafterSupplyParams[9].BaseCollectableRating", "HWDCrafterSupplyParams[10].BaseCollectableRating", "HWDCrafterSupplyParams[11].BaseCollectableRating", "HWDCrafterSupplyParams[12].BaseCollectableRating", "HWDCrafterSupplyParams[13].BaseCollectableRating", "HWDCrafterSupplyParams[14].BaseCollectableRating", "HWDCrafterSupplyParams[15].BaseCollectableRating", "HWDCrafterSupplyParams[16].BaseCollectableRating", "HWDCrafterSupplyParams[17].BaseCollectableRating", "HWDCrafterSupplyParams[18].BaseCollectableRating", "HWDCrafterSupplyParams[19].BaseCollectableRating", "HWDCrafterSupplyParams[20].BaseCollectableRating", "HWDCrafterSupplyParams[21].BaseCollectableRating", "HWDCrafterSupplyParams[22].BaseCollectableRating", "HWDCrafterSupplyParams[0].MidCollectableRating", "HWDCrafterSupplyParams[1].MidCollectableRating", "HWDCrafterSupplyParams[2].MidCollectableRating", "HWDCrafterSupplyParams[3].MidCollectableRating", "HWDCrafterSupplyParams[4].MidCollectableRating", "HWDCrafterSupplyParams[5].MidCollectableRating", "HWDCrafterSupplyParams[6].MidCollectableRating", "HWDCrafterSupplyParams[7].MidCollectableRating", "HWDCrafterSupplyParams[8].MidCollectableRating", "HWDCrafterSupplyParams[9].MidCollectableRating", "HWDCrafterSupplyParams[10].MidCollectableRating", "HWDCrafterSupplyParams[11].MidCollectableRating", "HWDCrafterSupplyParams[12].MidCollectableRating", "HWDCrafterSupplyParams[13].MidCollectableRating", "HWDCrafterSupplyParams[14].MidCollectableRating", "HWDCrafterSupplyParams[15].MidCollectableRating", "HWDCrafterSupplyParams[16].MidCollectableRating", "HWDCrafterSupplyParams[17].MidCollectableRating", "HWDCrafterSupplyParams[18].MidCollectableRating", "HWDCrafterSupplyParams[19].MidCollectableRating", "HWDCrafterSupplyParams[20].MidCollectableRating", "HWDCrafterSupplyParams[21].MidCollectableRating", "HWDCrafterSupplyParams[22].MidCollectableRating", "HWDCrafterSupplyParams[0].HighCollectableRating", "HWDCrafterSupplyParams[1].HighCollectableRating", "HWDCrafterSupplyParams[2].HighCollectableRating", "HWDCrafterSupplyParams[3].HighCollectableRating", "HWDCrafterSupplyParams[4].HighCollectableRating", "HWDCrafterSupplyParams[5].HighCollectableRating", "HWDCrafterSupplyParams[6].HighCollectableRating", "HWDCrafterSupplyParams[7].HighCollectableRating", "HWDCrafterSupplyParams[8].HighCollectableRating", "HWDCrafterSupplyParams[9].HighCollectableRating", "HWDCrafterSupplyParams[10].HighCollectableRating", "HWDCrafterSupplyParams[11].HighCollectableRating", "HWDCrafterSupplyParams[12].HighCollectableRating", "HWDCrafterSupplyParams[13].HighCollectableRating", "HWDCrafterSupplyParams[14].HighCollectableRating", "HWDCrafterSupplyParams[15].HighCollectableRating", "HWDCrafterSupplyParams[16].HighCollectableRating", "HWDCrafterSupplyParams[17].HighCollectableRating", "HWDCrafterSupplyParams[18].HighCollectableRating", "HWDCrafterSupplyParams[19].HighCollectableRating", "HWDCrafterSupplyParams[20].HighCollectableRating", "HWDCrafterSupplyParams[21].HighCollectableRating", "HWDCrafterSupplyParams[22].HighCollectableRating", "HWDCrafterSupplyParams[0].BaseCollectableReward", "HWDCrafterSupplyParams[1].BaseCollectableReward", "HWDCrafterSupplyParams[2].BaseCollectableReward", "HWDCrafterSupplyParams[3].BaseCollectableReward", "HWDCrafterSupplyParams[4].BaseCollectableReward", "HWDCrafterSupplyParams[5].BaseCollectableReward", "HWDCrafterSupplyParams[6].BaseCollectableReward", "HWDCrafterSupplyParams[7].BaseCollectableReward", "HWDCrafterSupplyParams[8].BaseCollectableReward", "HWDCrafterSupplyParams[9].BaseCollectableReward", "HWDCrafterSupplyParams[10].BaseCollectableReward", "HWDCrafterSupplyParams[11].BaseCollectableReward", "HWDCrafterSupplyParams[12].BaseCollectableReward", "HWDCrafterSupplyParams[13].BaseCollectableReward", "HWDCrafterSupplyParams[14].BaseCollectableReward", "HWDCrafterSupplyParams[15].BaseCollectableReward", "HWDCrafterSupplyParams[16].BaseCollectableReward", "HWDCrafterSupplyParams[17].BaseCollectableReward", "HWDCrafterSupplyParams[18].BaseCollectableReward", "HWDCrafterSupplyParams[19].BaseCollectableReward", "HWDCrafterSupplyParams[20].BaseCollectableReward", "HWDCrafterSupplyParams[21].BaseCollectableReward", "HWDCrafterSupplyParams[22].BaseCollectableReward", "HWDCrafterSupplyParams[0].MidCollectableReward", "HWDCrafterSupplyParams[1].MidCollectableReward", "HWDCrafterSupplyParams[2].MidCollectableReward", "HWDCrafterSupplyParams[3].MidCollectableReward", "HWDCrafterSupplyParams[4].MidCollectableReward", "HWDCrafterSupplyParams[5].MidCollectableReward", "HWDCrafterSupplyParams[6].MidCollectableReward", "HWDCrafterSupplyParams[7].MidCollectableReward", "HWDCrafterSupplyParams[8].MidCollectableReward", "HWDCrafterSupplyParams[9].MidCollectableReward", "HWDCrafterSupplyParams[10].MidCollectableReward", "HWDCrafterSupplyParams[11].MidCollectableReward", "HWDCrafterSupplyParams[12].MidCollectableReward", "HWDCrafterSupplyParams[13].MidCollectableReward", "HWDCrafterSupplyParams[14].MidCollectableReward", "HWDCrafterSupplyParams[15].MidCollectableReward", "HWDCrafterSupplyParams[16].MidCollectableReward", "HWDCrafterSupplyParams[17].MidCollectableReward", "HWDCrafterSupplyParams[18].MidCollectableReward", "HWDCrafterSupplyParams[19].MidCollectableReward", "HWDCrafterSupplyParams[20].MidCollectableReward", "HWDCrafterSupplyParams[21].MidCollectableReward", "HWDCrafterSupplyParams[22].MidCollectableReward", "HWDCrafterSupplyParams[0].HighCollectableReward", "HWDCrafterSupplyParams[1].HighCollectableReward", "HWDCrafterSupplyParams[2].HighCollectableReward", "HWDCrafterSupplyParams[3].HighCollectableReward", "HWDCrafterSupplyParams[4].HighCollectableReward", "HWDCrafterSupplyParams[5].HighCollectableReward", "HWDCrafterSupplyParams[6].HighCollectableReward", "HWDCrafterSupplyParams[7].HighCollectableReward", "HWDCrafterSupplyParams[8].HighCollectableReward", "HWDCrafterSupplyParams[9].HighCollectableReward", "HWDCrafterSupplyParams[10].HighCollectableReward", "HWDCrafterSupplyParams[11].HighCollectableReward", "HWDCrafterSupplyParams[12].HighCollectableReward", "HWDCrafterSupplyParams[13].HighCollectableReward", "HWDCrafterSupplyParams[14].HighCollectableReward", "HWDCrafterSupplyParams[15].HighCollectableReward", "HWDCrafterSupplyParams[16].HighCollectableReward", "HWDCrafterSupplyParams[17].HighCollectableReward", "HWDCrafterSupplyParams[18].HighCollectableReward", "HWDCrafterSupplyParams[19].HighCollectableReward", "HWDCrafterSupplyParams[20].HighCollectableReward", "HWDCrafterSupplyParams[21].HighCollectableReward", "HWDCrafterSupplyParams[22].HighCollectableReward", "HWDCrafterSupplyParams[0].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[1].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[2].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[3].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[4].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[5].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[6].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[7].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[8].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[9].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[10].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[11].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[12].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[13].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[14].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[15].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[16].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[17].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[18].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[19].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[20].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[21].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[22].BaseCollectableRewardPostPhase", "HWDCrafterSupplyParams[0].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[1].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[2].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[3].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[4].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[5].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[6].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[7].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[8].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[9].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[10].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[11].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[12].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[13].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[14].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[15].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[16].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[17].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[18].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[19].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[20].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[21].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[22].MidCollectableRewardPostPhase", "HWDCrafterSupplyParams[0].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[1].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[2].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[3].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[4].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[5].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[6].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[7].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[8].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[9].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[10].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[11].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[12].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[13].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[14].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[15].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[16].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[17].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[18].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[19].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[20].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[21].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[22].HighCollectableRewardPostPhase", "HWDCrafterSupplyParams[0].TermName", "HWDCrafterSupplyParams[1].TermName", "HWDCrafterSupplyParams[2].TermName", "HWDCrafterSupplyParams[3].TermName", "HWDCrafterSupplyParams[4].TermName", "HWDCrafterSupplyParams[5].TermName", "HWDCrafterSupplyParams[6].TermName", "HWDCrafterSupplyParams[7].TermName", "HWDCrafterSupplyParams[8].TermName", "HWDCrafterSupplyParams[9].TermName", "HWDCrafterSupplyParams[10].TermName", "HWDCrafterSupplyParams[11].TermName", "HWDCrafterSupplyParams[12].TermName", "HWDCrafterSupplyParams[13].TermName", "HWDCrafterSupplyParams[14].TermName", "HWDCrafterSupplyParams[15].TermName", "HWDCrafterSupplyParams[16].TermName", "HWDCrafterSupplyParams[17].TermName", "HWDCrafterSupplyParams[18].TermName", "HWDCrafterSupplyParams[19].TermName", "HWDCrafterSupplyParams[20].TermName", "HWDCrafterSupplyParams[21].TermName", "HWDCrafterSupplyParams[22].TermName" };

pub const hwd_crafter_supply_params_len = 23;
pub fn hwdCrafterSupplyParams(self: @This(), n0: usize) HWDCrafterSupplyParamsEntry {
    std.debug.assert(n0 < 23);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const HWDCrafterSupplyParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Item`.
    pub fn itemTradeIn(self: @This()) excel.Link(sheets.Item) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    pub fn baseCollectableRating(self: @This()) u16 {
        return self.row.at(u16, offsets_2[self.at[0]]);
    }

    pub fn midCollectableRating(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }

    pub fn highCollectableRating(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn baseCollectableReward(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_5[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn midCollectableReward(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_6[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn highCollectableReward(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_7[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn baseCollectableRewardPostPhase(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_8[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn midCollectableRewardPostPhase(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_9[self.at[0]]));
    }

    /// Links to `HWDCrafterSupplyReward`.
    pub fn highCollectableRewardPostPhase(self: @This()) excel.Link(sheets.HWDCrafterSupplyReward) {
        return .of(self.row.at(u16, offsets_10[self.at[0]]));
    }

    pub fn level(self: @This()) u8 {
        return self.row.at(u8, offsets_11[self.at[0]]);
    }

    pub fn levelMax(self: @This()) u8 {
        return self.row.at(u8, offsets_12[self.at[0]]);
    }

    pub fn unknown0(self: @This()) u8 {
        return self.row.at(u8, offsets_13[self.at[0]]);
    }

    /// Links to `HWDCrafterSupplyTerm`.
    pub fn termName(self: @This()) excel.Link(sheets.HWDCrafterSupplyTerm) {
        return .of(self.row.at(u8, offsets_14[self.at[0]]));
    }
};

const offsets_1 = [23]u16{ 0, 28, 56, 84, 112, 140, 168, 196, 224, 252, 280, 308, 336, 364, 392, 420, 448, 476, 504, 532, 560, 588, 616 };
const offsets_2 = [23]u16{ 4, 32, 60, 88, 116, 144, 172, 200, 228, 256, 284, 312, 340, 368, 396, 424, 452, 480, 508, 536, 564, 592, 620 };
const offsets_3 = [23]u16{ 6, 34, 62, 90, 118, 146, 174, 202, 230, 258, 286, 314, 342, 370, 398, 426, 454, 482, 510, 538, 566, 594, 622 };
const offsets_4 = [23]u16{ 8, 36, 64, 92, 120, 148, 176, 204, 232, 260, 288, 316, 344, 372, 400, 428, 456, 484, 512, 540, 568, 596, 624 };
const offsets_5 = [23]u16{ 10, 38, 66, 94, 122, 150, 178, 206, 234, 262, 290, 318, 346, 374, 402, 430, 458, 486, 514, 542, 570, 598, 626 };
const offsets_6 = [23]u16{ 12, 40, 68, 96, 124, 152, 180, 208, 236, 264, 292, 320, 348, 376, 404, 432, 460, 488, 516, 544, 572, 600, 628 };
const offsets_7 = [23]u16{ 14, 42, 70, 98, 126, 154, 182, 210, 238, 266, 294, 322, 350, 378, 406, 434, 462, 490, 518, 546, 574, 602, 630 };
const offsets_8 = [23]u16{ 16, 44, 72, 100, 128, 156, 184, 212, 240, 268, 296, 324, 352, 380, 408, 436, 464, 492, 520, 548, 576, 604, 632 };
const offsets_9 = [23]u16{ 18, 46, 74, 102, 130, 158, 186, 214, 242, 270, 298, 326, 354, 382, 410, 438, 466, 494, 522, 550, 578, 606, 634 };
const offsets_10 = [23]u16{ 20, 48, 76, 104, 132, 160, 188, 216, 244, 272, 300, 328, 356, 384, 412, 440, 468, 496, 524, 552, 580, 608, 636 };
const offsets_11 = [23]u16{ 22, 50, 78, 106, 134, 162, 190, 218, 246, 274, 302, 330, 358, 386, 414, 442, 470, 498, 526, 554, 582, 610, 638 };
const offsets_12 = [23]u16{ 23, 51, 79, 107, 135, 163, 191, 219, 247, 275, 303, 331, 359, 387, 415, 443, 471, 499, 527, 555, 583, 611, 639 };
const offsets_13 = [23]u16{ 24, 52, 80, 108, 136, 164, 192, 220, 248, 276, 304, 332, 360, 388, 416, 444, 472, 500, 528, 556, 584, 612, 640 };
const offsets_14 = [23]u16{ 25, 53, 81, 109, 137, 165, 193, 221, 249, 277, 305, 333, 361, 389, 417, 445, 473, 501, 529, 557, 585, 613, 641 };
