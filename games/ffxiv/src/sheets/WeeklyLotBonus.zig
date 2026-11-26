//! `WeeklyLotBonus`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeeklyLotBonus = @This();

pub const sheet_name = "WeeklyLotBonus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x69ba3687;
pub const Sheet = excel.Typed(WeeklyLotBonus);

row: excel.Row,

pub const weekly_lot_bonus_param_len = 32;
pub fn weeklyLotBonusParam(self: @This(), n0: usize) WeeklyLotBonusParamEntry {
    std.debug.assert(n0 < 32);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const WeeklyLotBonusParamEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn unknown0(self: @This()) u16 {
        return self.row.at(u16, offsets_1[self.at[0]]);
    }

    /// Links to `WeeklyLotBonusThreshold`.
    pub fn weeklyLotBonusThreshold(self: @This()) excel.Link(sheets.WeeklyLotBonusThreshold) {
        return .of(self.row.at(u8, offsets_2[self.at[0]]));
    }

    pub fn unknown1(self: @This()) u8 {
        return self.row.at(u8, offsets_3[self.at[0]]);
    }
};

const offsets_1 = [32]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124 };
const offsets_2 = [32]u16{ 2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126 };
const offsets_3 = [32]u16{ 3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75, 79, 83, 87, 91, 95, 99, 103, 107, 111, 115, 119, 123, 127 };
