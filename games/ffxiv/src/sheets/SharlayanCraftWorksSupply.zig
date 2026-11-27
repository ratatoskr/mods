//! `SharlayanCraftWorksSupply`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SharlayanCraftWorksSupply = @This();

pub const sheet_name = "SharlayanCraftWorksSupply";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x903b128e;
pub const Sheet = excel.Typed(SharlayanCraftWorksSupply);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item[0].Level", "Item[1].Level", "Item[2].Level", "Item[3].Level", "Item[0].ItemId", "Item[1].ItemId", "Item[2].ItemId", "Item[3].ItemId", "Item[0].CollectabilityMid", "Item[1].CollectabilityMid", "Item[2].CollectabilityMid", "Item[3].CollectabilityMid", "Item[0].CollectabilityHigh", "Item[1].CollectabilityHigh", "Item[2].CollectabilityHigh", "Item[3].CollectabilityHigh", "Item[0].XPReward", "Item[1].XPReward", "Item[2].XPReward", "Item[3].XPReward", "Item[0].HighXPMultiplier", "Item[1].HighXPMultiplier", "Item[2].HighXPMultiplier", "Item[3].HighXPMultiplier", "Item[0].GilReward", "Item[1].GilReward", "Item[2].GilReward", "Item[3].GilReward", "Item[0].HighGilMultiplier", "Item[1].HighGilMultiplier", "Item[2].HighGilMultiplier", "Item[3].HighGilMultiplier", "Item[0].Unknown8", "Item[1].Unknown8", "Item[2].Unknown8", "Item[3].Unknown8", "Item[0].ScripReward", "Item[1].ScripReward", "Item[2].ScripReward", "Item[3].ScripReward", "Item[0].HighScripMultiplier", "Item[1].HighScripMultiplier", "Item[2].HighScripMultiplier", "Item[3].HighScripMultiplier" };

pub const item_len = 4;
pub fn item(self: @This(), n0: usize) ItemEntry {
    std.debug.assert(n0 < 4);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const ItemEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Item`.
    pub fn itemId(self: @This()) excel.Link(sheets.Item) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    pub fn xpReward(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    pub fn collectabilityMid(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }

    pub fn collectabilityHigh(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }

    pub fn gilReward(self: @This()) u16 {
        return self.row.at(u16, offsets_5[self.at[0]]);
    }

    pub fn level(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn highXPMultiplier(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }

    pub fn highGilMultiplier(self: @This()) u8 {
        return self.row.at(u8, offsets_8[self.at[0]]);
    }

    pub fn unknown8(self: @This()) u8 {
        return self.row.at(u8, offsets_9[self.at[0]]);
    }

    pub fn scripReward(self: @This()) u8 {
        return self.row.at(u8, offsets_10[self.at[0]]);
    }

    pub fn highScripMultiplier(self: @This()) u8 {
        return self.row.at(u8, offsets_11[self.at[0]]);
    }
};

const offsets_1 = [4]u16{ 0, 20, 40, 60 };
const offsets_2 = [4]u16{ 4, 24, 44, 64 };
const offsets_3 = [4]u16{ 8, 28, 48, 68 };
const offsets_4 = [4]u16{ 10, 30, 50, 70 };
const offsets_5 = [4]u16{ 12, 32, 52, 72 };
const offsets_6 = [4]u16{ 14, 34, 54, 74 };
const offsets_7 = [4]u16{ 15, 35, 55, 75 };
const offsets_8 = [4]u16{ 16, 36, 56, 76 };
const offsets_9 = [4]u16{ 17, 37, 57, 77 };
const offsets_10 = [4]u16{ 18, 38, 58, 78 };
const offsets_11 = [4]u16{ 19, 39, 59, 79 };
