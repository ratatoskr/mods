//! `Spectator`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Spectator = @This();

pub const sheet_name = "Spectator";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbb5e90d9;
pub const Sheet = excel.Typed(Spectator);

row: excel.Row,

pub const spot_len = 8;
pub fn spot(self: @This(), n0: usize) SpotEntry {
    std.debug.assert(n0 < 8);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const SpotEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn x(self: @This()) f32 {
        return self.row.at(f32, offsets_1[self.at[0]]);
    }

    pub fn y(self: @This()) f32 {
        return self.row.at(f32, offsets_2[self.at[0]]);
    }

    pub fn z(self: @This()) f32 {
        return self.row.at(f32, offsets_3[self.at[0]]);
    }

    pub fn dirH(self: @This()) f32 {
        return self.row.at(f32, offsets_4[self.at[0]]);
    }

    pub fn dirV(self: @This()) f32 {
        return self.row.at(f32, offsets_5[self.at[0]]);
    }
};

pub fn unknown40(self: @This()) u8 {
    return self.row.at(u8, 160);
}

const offsets_1 = [8]u16{ 0, 20, 40, 60, 80, 100, 120, 140 };
const offsets_2 = [8]u16{ 4, 24, 44, 64, 84, 104, 124, 144 };
const offsets_3 = [8]u16{ 8, 28, 48, 68, 88, 108, 128, 148 };
const offsets_4 = [8]u16{ 12, 32, 52, 72, 92, 112, 132, 152 };
const offsets_5 = [8]u16{ 16, 36, 56, 76, 96, 116, 136, 156 };
