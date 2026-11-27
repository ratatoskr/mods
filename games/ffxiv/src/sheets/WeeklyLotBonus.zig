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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "WeeklyLotBonusParam[0].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[1].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[2].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[3].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[4].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[5].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[6].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[7].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[8].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[9].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[10].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[11].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[12].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[13].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[14].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[15].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[16].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[17].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[18].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[19].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[20].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[21].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[22].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[23].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[24].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[25].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[26].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[27].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[28].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[29].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[30].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[31].WeeklyLotBonusThreshold", "WeeklyLotBonusParam[0].Unknown0", "WeeklyLotBonusParam[1].Unknown0", "WeeklyLotBonusParam[2].Unknown0", "WeeklyLotBonusParam[3].Unknown0", "WeeklyLotBonusParam[4].Unknown0", "WeeklyLotBonusParam[5].Unknown0", "WeeklyLotBonusParam[6].Unknown0", "WeeklyLotBonusParam[7].Unknown0", "WeeklyLotBonusParam[8].Unknown0", "WeeklyLotBonusParam[9].Unknown0", "WeeklyLotBonusParam[10].Unknown0", "WeeklyLotBonusParam[11].Unknown0", "WeeklyLotBonusParam[12].Unknown0", "WeeklyLotBonusParam[13].Unknown0", "WeeklyLotBonusParam[14].Unknown0", "WeeklyLotBonusParam[15].Unknown0", "WeeklyLotBonusParam[16].Unknown0", "WeeklyLotBonusParam[17].Unknown0", "WeeklyLotBonusParam[18].Unknown0", "WeeklyLotBonusParam[19].Unknown0", "WeeklyLotBonusParam[20].Unknown0", "WeeklyLotBonusParam[21].Unknown0", "WeeklyLotBonusParam[22].Unknown0", "WeeklyLotBonusParam[23].Unknown0", "WeeklyLotBonusParam[24].Unknown0", "WeeklyLotBonusParam[25].Unknown0", "WeeklyLotBonusParam[26].Unknown0", "WeeklyLotBonusParam[27].Unknown0", "WeeklyLotBonusParam[28].Unknown0", "WeeklyLotBonusParam[29].Unknown0", "WeeklyLotBonusParam[30].Unknown0", "WeeklyLotBonusParam[31].Unknown0", "WeeklyLotBonusParam[0].Unknown1", "WeeklyLotBonusParam[1].Unknown1", "WeeklyLotBonusParam[2].Unknown1", "WeeklyLotBonusParam[3].Unknown1", "WeeklyLotBonusParam[4].Unknown1", "WeeklyLotBonusParam[5].Unknown1", "WeeklyLotBonusParam[6].Unknown1", "WeeklyLotBonusParam[7].Unknown1", "WeeklyLotBonusParam[8].Unknown1", "WeeklyLotBonusParam[9].Unknown1", "WeeklyLotBonusParam[10].Unknown1", "WeeklyLotBonusParam[11].Unknown1", "WeeklyLotBonusParam[12].Unknown1", "WeeklyLotBonusParam[13].Unknown1", "WeeklyLotBonusParam[14].Unknown1", "WeeklyLotBonusParam[15].Unknown1", "WeeklyLotBonusParam[16].Unknown1", "WeeklyLotBonusParam[17].Unknown1", "WeeklyLotBonusParam[18].Unknown1", "WeeklyLotBonusParam[19].Unknown1", "WeeklyLotBonusParam[20].Unknown1", "WeeklyLotBonusParam[21].Unknown1", "WeeklyLotBonusParam[22].Unknown1", "WeeklyLotBonusParam[23].Unknown1", "WeeklyLotBonusParam[24].Unknown1", "WeeklyLotBonusParam[25].Unknown1", "WeeklyLotBonusParam[26].Unknown1", "WeeklyLotBonusParam[27].Unknown1", "WeeklyLotBonusParam[28].Unknown1", "WeeklyLotBonusParam[29].Unknown1", "WeeklyLotBonusParam[30].Unknown1", "WeeklyLotBonusParam[31].Unknown1" };

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
