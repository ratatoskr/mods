//! `PvPSeries`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPSeries = @This();

pub const sheet_name = "PvPSeries";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x45504238;
pub const Sheet = excel.Typed(PvPSeries);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "LevelRewards[0].LevelRewardItem[0]", "LevelRewards[1].LevelRewardItem[0]", "LevelRewards[2].LevelRewardItem[0]", "LevelRewards[3].LevelRewardItem[0]", "LevelRewards[4].LevelRewardItem[0]", "LevelRewards[5].LevelRewardItem[0]", "LevelRewards[6].LevelRewardItem[0]", "LevelRewards[7].LevelRewardItem[0]", "LevelRewards[8].LevelRewardItem[0]", "LevelRewards[9].LevelRewardItem[0]", "LevelRewards[10].LevelRewardItem[0]", "LevelRewards[11].LevelRewardItem[0]", "LevelRewards[12].LevelRewardItem[0]", "LevelRewards[13].LevelRewardItem[0]", "LevelRewards[14].LevelRewardItem[0]", "LevelRewards[15].LevelRewardItem[0]", "LevelRewards[16].LevelRewardItem[0]", "LevelRewards[17].LevelRewardItem[0]", "LevelRewards[18].LevelRewardItem[0]", "LevelRewards[19].LevelRewardItem[0]", "LevelRewards[20].LevelRewardItem[0]", "LevelRewards[21].LevelRewardItem[0]", "LevelRewards[22].LevelRewardItem[0]", "LevelRewards[23].LevelRewardItem[0]", "LevelRewards[24].LevelRewardItem[0]", "LevelRewards[25].LevelRewardItem[0]", "LevelRewards[26].LevelRewardItem[0]", "LevelRewards[27].LevelRewardItem[0]", "LevelRewards[28].LevelRewardItem[0]", "LevelRewards[29].LevelRewardItem[0]", "LevelRewards[30].LevelRewardItem[0]", "LevelRewards[31].LevelRewardItem[0]", "LevelRewards[0].LevelRewardItem[1]", "LevelRewards[1].LevelRewardItem[1]", "LevelRewards[2].LevelRewardItem[1]", "LevelRewards[3].LevelRewardItem[1]", "LevelRewards[4].LevelRewardItem[1]", "LevelRewards[5].LevelRewardItem[1]", "LevelRewards[6].LevelRewardItem[1]", "LevelRewards[7].LevelRewardItem[1]", "LevelRewards[8].LevelRewardItem[1]", "LevelRewards[9].LevelRewardItem[1]", "LevelRewards[10].LevelRewardItem[1]", "LevelRewards[11].LevelRewardItem[1]", "LevelRewards[12].LevelRewardItem[1]", "LevelRewards[13].LevelRewardItem[1]", "LevelRewards[14].LevelRewardItem[1]", "LevelRewards[15].LevelRewardItem[1]", "LevelRewards[16].LevelRewardItem[1]", "LevelRewards[17].LevelRewardItem[1]", "LevelRewards[18].LevelRewardItem[1]", "LevelRewards[19].LevelRewardItem[1]", "LevelRewards[20].LevelRewardItem[1]", "LevelRewards[21].LevelRewardItem[1]", "LevelRewards[22].LevelRewardItem[1]", "LevelRewards[23].LevelRewardItem[1]", "LevelRewards[24].LevelRewardItem[1]", "LevelRewards[25].LevelRewardItem[1]", "LevelRewards[26].LevelRewardItem[1]", "LevelRewards[27].LevelRewardItem[1]", "LevelRewards[28].LevelRewardItem[1]", "LevelRewards[29].LevelRewardItem[1]", "LevelRewards[30].LevelRewardItem[1]", "LevelRewards[31].LevelRewardItem[1]", "LevelRewards[0].LevelRewardCount[0]", "LevelRewards[1].LevelRewardCount[0]", "LevelRewards[2].LevelRewardCount[0]", "LevelRewards[3].LevelRewardCount[0]", "LevelRewards[4].LevelRewardCount[0]", "LevelRewards[5].LevelRewardCount[0]", "LevelRewards[6].LevelRewardCount[0]", "LevelRewards[7].LevelRewardCount[0]", "LevelRewards[8].LevelRewardCount[0]", "LevelRewards[9].LevelRewardCount[0]", "LevelRewards[10].LevelRewardCount[0]", "LevelRewards[11].LevelRewardCount[0]", "LevelRewards[12].LevelRewardCount[0]", "LevelRewards[13].LevelRewardCount[0]", "LevelRewards[14].LevelRewardCount[0]", "LevelRewards[15].LevelRewardCount[0]", "LevelRewards[16].LevelRewardCount[0]", "LevelRewards[17].LevelRewardCount[0]", "LevelRewards[18].LevelRewardCount[0]", "LevelRewards[19].LevelRewardCount[0]", "LevelRewards[20].LevelRewardCount[0]", "LevelRewards[21].LevelRewardCount[0]", "LevelRewards[22].LevelRewardCount[0]", "LevelRewards[23].LevelRewardCount[0]", "LevelRewards[24].LevelRewardCount[0]", "LevelRewards[25].LevelRewardCount[0]", "LevelRewards[26].LevelRewardCount[0]", "LevelRewards[27].LevelRewardCount[0]", "LevelRewards[28].LevelRewardCount[0]", "LevelRewards[29].LevelRewardCount[0]", "LevelRewards[30].LevelRewardCount[0]", "LevelRewards[31].LevelRewardCount[0]", "LevelRewards[0].LevelRewardCount[1]", "LevelRewards[1].LevelRewardCount[1]", "LevelRewards[2].LevelRewardCount[1]", "LevelRewards[3].LevelRewardCount[1]", "LevelRewards[4].LevelRewardCount[1]", "LevelRewards[5].LevelRewardCount[1]", "LevelRewards[6].LevelRewardCount[1]", "LevelRewards[7].LevelRewardCount[1]", "LevelRewards[8].LevelRewardCount[1]", "LevelRewards[9].LevelRewardCount[1]", "LevelRewards[10].LevelRewardCount[1]", "LevelRewards[11].LevelRewardCount[1]", "LevelRewards[12].LevelRewardCount[1]", "LevelRewards[13].LevelRewardCount[1]", "LevelRewards[14].LevelRewardCount[1]", "LevelRewards[15].LevelRewardCount[1]", "LevelRewards[16].LevelRewardCount[1]", "LevelRewards[17].LevelRewardCount[1]", "LevelRewards[18].LevelRewardCount[1]", "LevelRewards[19].LevelRewardCount[1]", "LevelRewards[20].LevelRewardCount[1]", "LevelRewards[21].LevelRewardCount[1]", "LevelRewards[22].LevelRewardCount[1]", "LevelRewards[23].LevelRewardCount[1]", "LevelRewards[24].LevelRewardCount[1]", "LevelRewards[25].LevelRewardCount[1]", "LevelRewards[26].LevelRewardCount[1]", "LevelRewards[27].LevelRewardCount[1]", "LevelRewards[28].LevelRewardCount[1]", "LevelRewards[29].LevelRewardCount[1]", "LevelRewards[30].LevelRewardCount[1]", "LevelRewards[31].LevelRewardCount[1]", "LevelRewards[0].Unknown0", "LevelRewards[1].Unknown0", "LevelRewards[2].Unknown0", "LevelRewards[3].Unknown0", "LevelRewards[4].Unknown0", "LevelRewards[5].Unknown0", "LevelRewards[6].Unknown0", "LevelRewards[7].Unknown0", "LevelRewards[8].Unknown0", "LevelRewards[9].Unknown0", "LevelRewards[10].Unknown0", "LevelRewards[11].Unknown0", "LevelRewards[12].Unknown0", "LevelRewards[13].Unknown0", "LevelRewards[14].Unknown0", "LevelRewards[15].Unknown0", "LevelRewards[16].Unknown0", "LevelRewards[17].Unknown0", "LevelRewards[18].Unknown0", "LevelRewards[19].Unknown0", "LevelRewards[20].Unknown0", "LevelRewards[21].Unknown0", "LevelRewards[22].Unknown0", "LevelRewards[23].Unknown0", "LevelRewards[24].Unknown0", "LevelRewards[25].Unknown0", "LevelRewards[26].Unknown0", "LevelRewards[27].Unknown0", "LevelRewards[28].Unknown0", "LevelRewards[29].Unknown0", "LevelRewards[30].Unknown0", "LevelRewards[31].Unknown0" };

pub const level_rewards_len = 32;
pub fn levelRewards(self: @This(), n0: usize) LevelRewardsEntry {
    std.debug.assert(n0 < 32);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const LevelRewardsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub const level_reward_item_len = 2;
    /// Links to `Item`.
    pub fn levelRewardItem(self: @This(), n1: usize) excel.Link(sheets.Item) {
        return .of(self.row.at(i32, offsets_1[self.at[0]][n1]));
    }

    pub fn unknown0(self: @This()) i32 {
        return self.row.at(i32, offsets_2[self.at[0]]);
    }

    pub const level_reward_count_len = 2;
    pub fn levelRewardCount(self: @This(), n1: usize) u16 {
        return self.row.at(u16, offsets_3[self.at[0]][n1]);
    }
};

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 512);
}

const offsets_1 = [32][2]u16{ .{ 0, 4 }, .{ 16, 20 }, .{ 32, 36 }, .{ 48, 52 }, .{ 64, 68 }, .{ 80, 84 }, .{ 96, 100 }, .{ 112, 116 }, .{ 128, 132 }, .{ 144, 148 }, .{ 160, 164 }, .{ 176, 180 }, .{ 192, 196 }, .{ 208, 212 }, .{ 224, 228 }, .{ 240, 244 }, .{ 256, 260 }, .{ 272, 276 }, .{ 288, 292 }, .{ 304, 308 }, .{ 320, 324 }, .{ 336, 340 }, .{ 352, 356 }, .{ 368, 372 }, .{ 384, 388 }, .{ 400, 404 }, .{ 416, 420 }, .{ 432, 436 }, .{ 448, 452 }, .{ 464, 468 }, .{ 480, 484 }, .{ 496, 500 } };
const offsets_2 = [32]u16{ 8, 24, 40, 56, 72, 88, 104, 120, 136, 152, 168, 184, 200, 216, 232, 248, 264, 280, 296, 312, 328, 344, 360, 376, 392, 408, 424, 440, 456, 472, 488, 504 };
const offsets_3 = [32][2]u16{ .{ 12, 14 }, .{ 28, 30 }, .{ 44, 46 }, .{ 60, 62 }, .{ 76, 78 }, .{ 92, 94 }, .{ 108, 110 }, .{ 124, 126 }, .{ 140, 142 }, .{ 156, 158 }, .{ 172, 174 }, .{ 188, 190 }, .{ 204, 206 }, .{ 220, 222 }, .{ 236, 238 }, .{ 252, 254 }, .{ 268, 270 }, .{ 284, 286 }, .{ 300, 302 }, .{ 316, 318 }, .{ 332, 334 }, .{ 348, 350 }, .{ 364, 366 }, .{ 380, 382 }, .{ 396, 398 }, .{ 412, 414 }, .{ 428, 430 }, .{ 444, 446 }, .{ 460, 462 }, .{ 476, 478 }, .{ 492, 494 }, .{ 508, 510 } };
