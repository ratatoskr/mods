//! `GcArmyExpedition`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyExpedition = @This();

pub const sheet_name = "GcArmyExpedition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x852cc288;
pub const Sheet = excel.Typed(GcArmyExpedition);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub const expedition_params_len = 6;
pub fn expeditionParams(self: @This(), n0: usize) ExpeditionParamsEntry {
    std.debug.assert(n0 < 6);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const ExpeditionParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Item`.
    pub fn rewardItem(self: @This()) excel.Link(sheets.Item) {
        return .of(self.row.at(i32, offsets_1[self.at[0]]));
    }

    pub fn requiredPhysical(self: @This()) u16 {
        return self.row.at(u16, offsets_2[self.at[0]]);
    }

    pub fn requiredMental(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }

    pub fn requiredTactical(self: @This()) u16 {
        return self.row.at(u16, offsets_4[self.at[0]]);
    }

    pub fn rewardQuantity(self: @This()) u8 {
        return self.row.at(u8, offsets_5[self.at[0]]);
    }

    pub fn percentPhysicalMet(self: @This()) u8 {
        return self.row.at(u8, offsets_6[self.at[0]]);
    }

    pub fn percentMentalMet(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }

    pub fn percentTacticalMet(self: @This()) u8 {
        return self.row.at(u8, offsets_8[self.at[0]]);
    }

    pub fn percentAllMet(self: @This()) u8 {
        return self.row.at(u8, offsets_9[self.at[0]]);
    }
};

pub fn rewardExperience(self: @This()) u32 {
    return self.row.at(u32, 104);
}

pub fn requiredSeals(self: @This()) u16 {
    return self.row.at(u16, 108);
}

pub fn requiredFlag(self: @This()) u8 {
    return self.row.at(u8, 110);
}

pub fn unlockFlag(self: @This()) u8 {
    return self.row.at(u8, 111);
}

pub fn requiredLevel(self: @This()) u8 {
    return self.row.at(u8, 112);
}

pub fn percentBase(self: @This()) u8 {
    return self.row.at(u8, 113);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 114);
}

/// Links to `GcArmyExpeditionType`.
pub fn gcArmyExpeditionType(self: @This()) excel.Link(sheets.GcArmyExpeditionType) {
    return .of(self.row.at(u8, 115));
}

const offsets_1 = [6]u16{ 8, 24, 40, 56, 72, 88 };
const offsets_2 = [6]u16{ 12, 28, 44, 60, 76, 92 };
const offsets_3 = [6]u16{ 14, 30, 46, 62, 78, 94 };
const offsets_4 = [6]u16{ 16, 32, 48, 64, 80, 96 };
const offsets_5 = [6]u16{ 18, 34, 50, 66, 82, 98 };
const offsets_6 = [6]u16{ 19, 35, 51, 67, 83, 99 };
const offsets_7 = [6]u16{ 20, 36, 52, 68, 84, 100 };
const offsets_8 = [6]u16{ 21, 37, 53, 69, 85, 101 };
const offsets_9 = [6]u16{ 22, 38, 54, 70, 86, 102 };
