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
