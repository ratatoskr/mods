//! `BankaCraftWorksSupply`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BankaCraftWorksSupply = @This();

pub const sheet_name = "BankaCraftWorksSupply";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x444a6117;
pub const Sheet = excel.Typed(BankaCraftWorksSupply);

row: excel.Row,

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

    /// Links to `CollectablesRefine`.
    pub fn collectability(self: @This()) excel.Link(sheets.CollectablesRefine) {
        return .of(self.row.at(u16, offsets_3[self.at[0]]));
    }

    pub fn gilReward(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }

    pub fn level(self: @This()) u8 {
        return self.row.at(u8, offsets_5[self.at[0]]);
    }

    pub fn highXPMultiplier(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn highGilMultiplier(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }

    pub fn unknown8(self: @This()) u8 {
        return self.row.at(u8, offsets_8[self.at[0]]);
    }

    pub fn scripReward(self: @This()) u8 {
        return self.row.at(u8, offsets_9[self.at[0]]);
    }

    pub fn highScripMultiplier(self: @This()) u8 {
        return self.row.at(u8, offsets_10[self.at[0]]);
    }
};

const offsets_1 = [4]u16{ 0, 20, 40, 60 };
const offsets_2 = [4]u16{ 4, 24, 44, 64 };
const offsets_3 = [4]u16{ 8, 28, 48, 68 };
const offsets_4 = [4]u16{ 10, 30, 50, 70 };
const offsets_5 = [4]u16{ 12, 32, 52, 72 };
const offsets_6 = [4]u16{ 13, 33, 53, 73 };
const offsets_7 = [4]u16{ 14, 34, 54, 74 };
const offsets_8 = [4]u16{ 15, 35, 55, 75 };
const offsets_9 = [4]u16{ 16, 36, 56, 76 };
const offsets_10 = [4]u16{ 17, 37, 57, 77 };
