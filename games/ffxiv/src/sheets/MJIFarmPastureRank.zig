//! `MJIFarmPastureRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIFarmPastureRank = @This();

pub const sheet_name = "MJIFarmPastureRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7157b32e;
pub const Sheet = excel.Typed(MJIFarmPastureRank);

row: excel.Row,

pub const rank_data_len = 4;
pub fn rankData(self: @This(), n0: usize) RankDataEntry {
    std.debug.assert(n0 < 4);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const RankDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub const sgb_len = 4;
    /// Links to `ExportedSG`.
    pub fn sgb(self: @This(), n1: usize) excel.Link(sheets.ExportedSG) {
        return .of(self.row.at(u32, offsets_1[self.at[0]][n1]));
    }

    pub fn unknown0(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    pub fn unknown1(self: @This()) u32 {
        return self.row.at(u32, offsets_3[self.at[0]]);
    }

    pub fn unknown2(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }

    pub fn unknown3(self: @This()) u16 {
        return self.row.at(u16, offsets_5[self.at[0]]);
    }

    pub fn unknown4(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn unknown5(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }

    pub fn unknown6(self: @This()) u8 {
        return self.row.at(u8, offsets_8[self.at[0]]);
    }

    pub fn unknown7(self: @This()) u8 {
        return self.row.at(u8, offsets_9[self.at[0]]);
    }
};

const offsets_1 = [4][4]u16{ .{ 0, 4, 8, 12 }, .{ 32, 36, 40, 44 }, .{ 64, 68, 72, 76 }, .{ 96, 100, 104, 108 } };
const offsets_2 = [4]u16{ 16, 48, 80, 112 };
const offsets_3 = [4]u16{ 20, 52, 84, 116 };
const offsets_4 = [4]u16{ 24, 56, 88, 120 };
const offsets_5 = [4]u16{ 26, 58, 90, 122 };
const offsets_6 = [4]u16{ 28, 60, 92, 124 };
const offsets_7 = [4]u16{ 29, 61, 93, 125 };
const offsets_8 = [4]u16{ 30, 62, 94, 126 };
const offsets_9 = [4]u16{ 31, 63, 95, 127 };
