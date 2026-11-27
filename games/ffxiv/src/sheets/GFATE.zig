//! `GFATE`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Type`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GFATE = @This();

pub const sheet_name = "GFATE";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x440a2c22;
pub const Sheet = excel.Typed(GFATE);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "Location", "BGM", "Unknown7", "Unknown8", "Unknown9", "Unknown6", "GFATEParams[0].LGBPopRange", "GFATEParams[1].LGBPopRange", "GFATEParams[2].LGBPopRange", "GFATEParams[3].LGBPopRange", "GFATEParams[4].LGBPopRange", "GFATEParams[5].LGBPopRange", "GFATEParams[6].LGBPopRange", "GFATEParams[7].LGBPopRange", "GFATEParams[8].LGBPopRange", "GFATEParams[9].LGBPopRange", "GFATEParams[10].LGBPopRange", "GFATEParams[11].LGBPopRange", "GFATEParams[12].LGBPopRange", "GFATEParams[13].LGBPopRange", "GFATEParams[14].LGBPopRange", "GFATEParams[15].LGBPopRange", "GFATEParams[0].Icon", "GFATEParams[1].Icon", "GFATEParams[2].Icon", "GFATEParams[3].Icon", "GFATEParams[4].Icon", "GFATEParams[5].Icon", "GFATEParams[6].Icon", "GFATEParams[7].Icon", "GFATEParams[8].Icon", "GFATEParams[9].Icon", "GFATEParams[10].Icon", "GFATEParams[11].Icon", "GFATEParams[12].Icon", "GFATEParams[13].Icon", "GFATEParams[14].Icon", "GFATEParams[15].Icon", "GFATEParams[0].Unknown0", "GFATEParams[1].Unknown0", "GFATEParams[2].Unknown0", "GFATEParams[3].Unknown0", "GFATEParams[4].Unknown0", "GFATEParams[5].Unknown0", "GFATEParams[6].Unknown0", "GFATEParams[7].Unknown0", "GFATEParams[8].Unknown0", "GFATEParams[9].Unknown0", "GFATEParams[10].Unknown0", "GFATEParams[11].Unknown0", "GFATEParams[12].Unknown0", "GFATEParams[13].Unknown0", "GFATEParams[14].Unknown0", "GFATEParams[15].Unknown0", "GFATEParams[0].Unknown1", "GFATEParams[1].Unknown1", "GFATEParams[2].Unknown1", "GFATEParams[3].Unknown1", "GFATEParams[4].Unknown1", "GFATEParams[5].Unknown1", "GFATEParams[6].Unknown1", "GFATEParams[7].Unknown1", "GFATEParams[8].Unknown1", "GFATEParams[9].Unknown1", "GFATEParams[10].Unknown1", "GFATEParams[11].Unknown1", "GFATEParams[12].Unknown1", "GFATEParams[13].Unknown1", "GFATEParams[14].Unknown1", "GFATEParams[15].Unknown1", "GFATEParams[0].Unknown2", "GFATEParams[1].Unknown2", "GFATEParams[2].Unknown2", "GFATEParams[3].Unknown2", "GFATEParams[4].Unknown2", "GFATEParams[5].Unknown2", "GFATEParams[6].Unknown2", "GFATEParams[7].Unknown2", "GFATEParams[8].Unknown2", "GFATEParams[9].Unknown2", "GFATEParams[10].Unknown2", "GFATEParams[11].Unknown2", "GFATEParams[12].Unknown2", "GFATEParams[13].Unknown2", "GFATEParams[14].Unknown2", "GFATEParams[15].Unknown2" };

pub const gfate_params_len = 16;
pub fn gfateParams(self: @This(), n0: usize) GFATEParamsEntry {
    std.debug.assert(n0 < 16);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const GFATEParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Level`.
    pub fn lgbPopRange(self: @This()) excel.Link(sheets.Level) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn icon(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    pub fn unknown0(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_3[self.at[0]] >> 3), @intCast(offsets_3[self.at[0]] & 7));
    }

    pub fn unknown1(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_4[self.at[0]] >> 3), @intCast(offsets_4[self.at[0]] & 7));
    }

    pub fn unknown2(self: @This()) bool {
        return self.row.bitAt(@intCast(offsets_5[self.at[0]] >> 3), @intCast(offsets_5[self.at[0]] & 7));
    }
};

/// Links to `BGM`.
pub fn bgm(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u32, 192));
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 196);
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 200);
}

pub fn unknown8(self: @This()) u16 {
    return self.row.at(u16, 202);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 204);
}

/// Links to `GFateType`.
pub fn @"type"(self: @This()) excel.Link(sheets.GFateType) {
    return .of(self.row.at(u8, 206));
}

/// 1 = Wonder Square East
/// 2 = Event Square
/// 3 = Round Square
pub fn location(self: @This()) u8 {
    return self.row.at(u8, 207);
}

const offsets_1 = [16]u16{ 0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 144, 156, 168, 180 };
const offsets_2 = [16]u16{ 4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124, 136, 148, 160, 172, 184 };
const offsets_3 = [16]u32{ 64, 160, 256, 352, 448, 544, 640, 736, 832, 928, 1024, 1120, 1216, 1312, 1408, 1504 };
const offsets_4 = [16]u32{ 65, 161, 257, 353, 449, 545, 641, 737, 833, 929, 1025, 1121, 1217, 1313, 1409, 1505 };
const offsets_5 = [16]u32{ 66, 162, 258, 354, 450, 546, 642, 738, 834, 930, 1026, 1122, 1218, 1314, 1410, 1506 };
