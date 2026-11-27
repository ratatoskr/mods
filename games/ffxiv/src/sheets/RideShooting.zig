//! `RideShooting`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RideShooting = @This();

pub const sheet_name = "RideShooting";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdd593ecd;
pub const Sheet = excel.Typed(RideShooting);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "GFateRideShooting", "Unknown2", "Unknown3", "Unknown0", "Unknown1", "StartText", "RideShootingParams[0].Unknown0", "RideShootingParams[1].Unknown0", "RideShootingParams[2].Unknown0", "RideShootingParams[3].Unknown0", "RideShootingParams[4].Unknown0", "RideShootingParams[5].Unknown0", "RideShootingParams[6].Unknown0", "RideShootingParams[7].Unknown0", "RideShootingParams[0].PopRange", "RideShootingParams[1].PopRange", "RideShootingParams[2].PopRange", "RideShootingParams[3].PopRange", "RideShootingParams[4].PopRange", "RideShootingParams[5].PopRange", "RideShootingParams[6].PopRange", "RideShootingParams[7].PopRange", "RideShootingParams[0].ENpc", "RideShootingParams[1].ENpc", "RideShootingParams[2].ENpc", "RideShootingParams[3].ENpc", "RideShootingParams[4].ENpc", "RideShootingParams[5].ENpc", "RideShootingParams[6].ENpc", "RideShootingParams[7].ENpc", "RideShootingParams[0].ENpcScale", "RideShootingParams[1].ENpcScale", "RideShootingParams[2].ENpcScale", "RideShootingParams[3].ENpcScale", "RideShootingParams[4].ENpcScale", "RideShootingParams[5].ENpcScale", "RideShootingParams[6].ENpcScale", "RideShootingParams[7].ENpcScale", "RideShootingParams[0].Unknown1", "RideShootingParams[1].Unknown1", "RideShootingParams[2].Unknown1", "RideShootingParams[3].Unknown1", "RideShootingParams[4].Unknown1", "RideShootingParams[5].Unknown1", "RideShootingParams[6].Unknown1", "RideShootingParams[7].Unknown1", "RideShootingParams[0].Unknown6", "RideShootingParams[1].Unknown6", "RideShootingParams[2].Unknown6", "RideShootingParams[3].Unknown6", "RideShootingParams[4].Unknown6", "RideShootingParams[5].Unknown6", "RideShootingParams[6].Unknown6", "RideShootingParams[7].Unknown6", "RideShootingParams[0].Unknown2", "RideShootingParams[1].Unknown2", "RideShootingParams[2].Unknown2", "RideShootingParams[3].Unknown2", "RideShootingParams[4].Unknown2", "RideShootingParams[5].Unknown2", "RideShootingParams[6].Unknown2", "RideShootingParams[7].Unknown2", "RideShootingParams[0].Unknown7", "RideShootingParams[1].Unknown7", "RideShootingParams[2].Unknown7", "RideShootingParams[3].Unknown7", "RideShootingParams[4].Unknown7", "RideShootingParams[5].Unknown7", "RideShootingParams[6].Unknown7", "RideShootingParams[7].Unknown7", "RideShootingParams[0].Unknown3", "RideShootingParams[1].Unknown3", "RideShootingParams[2].Unknown3", "RideShootingParams[3].Unknown3", "RideShootingParams[4].Unknown3", "RideShootingParams[5].Unknown3", "RideShootingParams[6].Unknown3", "RideShootingParams[7].Unknown3", "RideShootingParams[0].Unknown8", "RideShootingParams[1].Unknown8", "RideShootingParams[2].Unknown8", "RideShootingParams[3].Unknown8", "RideShootingParams[4].Unknown8", "RideShootingParams[5].Unknown8", "RideShootingParams[6].Unknown8", "RideShootingParams[7].Unknown8", "RideShootingParams[0].Unknown4", "RideShootingParams[1].Unknown4", "RideShootingParams[2].Unknown4", "RideShootingParams[3].Unknown4", "RideShootingParams[4].Unknown4", "RideShootingParams[5].Unknown4", "RideShootingParams[6].Unknown4", "RideShootingParams[7].Unknown4", "RideShootingParams[0].Unknown9", "RideShootingParams[1].Unknown9", "RideShootingParams[2].Unknown9", "RideShootingParams[3].Unknown9", "RideShootingParams[4].Unknown9", "RideShootingParams[5].Unknown9", "RideShootingParams[6].Unknown9", "RideShootingParams[7].Unknown9", "RideShootingParams[0].Unknown5", "RideShootingParams[1].Unknown5", "RideShootingParams[2].Unknown5", "RideShootingParams[3].Unknown5", "RideShootingParams[4].Unknown5", "RideShootingParams[5].Unknown5", "RideShootingParams[6].Unknown5", "RideShootingParams[7].Unknown5", "RideShootingParams[0].Unknown10", "RideShootingParams[1].Unknown10", "RideShootingParams[2].Unknown10", "RideShootingParams[3].Unknown10", "RideShootingParams[4].Unknown10", "RideShootingParams[5].Unknown10", "RideShootingParams[6].Unknown10", "RideShootingParams[7].Unknown10" };

pub const ride_shooting_params_len = 8;
pub fn rideShootingParams(self: @This(), n0: usize) RideShootingParamsEntry {
    std.debug.assert(n0 < 8);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const RideShootingParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn unknown0(self: @This()) u32 {
        return self.row.at(u32, offsets_1[self.at[0]]);
    }

    pub fn popRange(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    /// Links to `ENpcBase`.
    pub fn eNpc(self: @This()) excel.Link(sheets.ENpcBase) {
        return .of(self.row.at(u32, offsets_3[self.at[0]]));
    }

    pub fn unknown1(self: @This()) u32 {
        return self.row.at(u32, offsets_4[self.at[0]]);
    }

    pub fn unknown2(self: @This()) u32 {
        return self.row.at(u32, offsets_5[self.at[0]]);
    }

    pub fn unknown3(self: @This()) u32 {
        return self.row.at(u32, offsets_6[self.at[0]]);
    }

    pub fn unknown4(self: @This()) u32 {
        return self.row.at(u32, offsets_7[self.at[0]]);
    }

    pub fn unknown5(self: @This()) u32 {
        return self.row.at(u32, offsets_8[self.at[0]]);
    }

    pub fn eNpcScale(self: @This()) u8 {
        return self.row.at(u8, offsets_9[self.at[0]]);
    }

    pub fn unknown6(self: @This()) u8 {
        return self.row.at(u8, offsets_10[self.at[0]]);
    }

    pub fn unknown7(self: @This()) u8 {
        return self.row.at(u8, offsets_11[self.at[0]]);
    }

    pub fn unknown8(self: @This()) u8 {
        return self.row.at(u8, offsets_12[self.at[0]]);
    }

    pub fn unknown9(self: @This()) u8 {
        return self.row.at(u8, offsets_13[self.at[0]]);
    }

    pub fn unknown10(self: @This()) u8 {
        return self.row.at(u8, offsets_14[self.at[0]]);
    }
};

/// Links to `GFateRideShooting`.
pub fn gFateRideShooting(self: @This()) excel.Link(sheets.GFateRideShooting) {
    return .of(self.row.at(u16, 320));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 322);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 324);
}

/// Links to `RideShootingTextData`.
pub fn startText(self: @This()) excel.Link(sheets.RideShootingTextData) {
    return .of(self.row.at(u16, 326));
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 328);
}

pub fn unknown3(self: @This()) i16 {
    return self.row.at(i16, 330);
}

const offsets_1 = [8]u16{ 0, 40, 80, 120, 160, 200, 240, 280 };
const offsets_2 = [8]u16{ 4, 44, 84, 124, 164, 204, 244, 284 };
const offsets_3 = [8]u16{ 8, 48, 88, 128, 168, 208, 248, 288 };
const offsets_4 = [8]u16{ 12, 52, 92, 132, 172, 212, 252, 292 };
const offsets_5 = [8]u16{ 16, 56, 96, 136, 176, 216, 256, 296 };
const offsets_6 = [8]u16{ 20, 60, 100, 140, 180, 220, 260, 300 };
const offsets_7 = [8]u16{ 24, 64, 104, 144, 184, 224, 264, 304 };
const offsets_8 = [8]u16{ 28, 68, 108, 148, 188, 228, 268, 308 };
const offsets_9 = [8]u16{ 32, 72, 112, 152, 192, 232, 272, 312 };
const offsets_10 = [8]u16{ 33, 73, 113, 153, 193, 233, 273, 313 };
const offsets_11 = [8]u16{ 34, 74, 114, 154, 194, 234, 274, 314 };
const offsets_12 = [8]u16{ 35, 75, 115, 155, 195, 235, 275, 315 };
const offsets_13 = [8]u16{ 36, 76, 116, 156, 196, 236, 276, 316 };
const offsets_14 = [8]u16{ 37, 77, 117, 157, 197, 237, 277, 317 };
