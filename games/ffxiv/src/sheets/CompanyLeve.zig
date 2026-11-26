//! `CompanyLeve`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanyLeve = @This();

pub const sheet_name = "CompanyLeve";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x688cf3da;
pub const Sheet = excel.Typed(CompanyLeve);

row: excel.Row,

pub const route_point_time_len = 8;
pub fn routePointTime(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_1[n0]);
}

pub const company_leve_struct_len = 8;
pub fn companyLeveStruct(self: @This(), n0: usize) CompanyLeveStructEntry {
    std.debug.assert(n0 < 8);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const CompanyLeveStructEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `BNpcName`.
    pub fn bNpcName(self: @This()) excel.Link(sheets.BNpcName) {
        return .of(self.row.at(u32, offsets_2[self.at[0]]));
    }

    pub const to_do_param_len = 6;
    pub fn toDoParam(self: @This(), n1: usize) u32 {
        return self.row.at(u32, offsets_3[self.at[0]][n1]);
    }

    /// Links to `EventItem` or `BNpcBase`, whichever has the row.
    pub fn baseID(self: @This()) i32 {
        return self.row.at(i32, offsets_4[self.at[0]]);
    }

    /// Links to `EventItem`.
    pub fn itemsInvolved(self: @This()) excel.Link(sheets.EventItem) {
        return .of(self.row.at(i32, offsets_5[self.at[0]]));
    }

    pub fn enemyLevel(self: @This()) u16 {
        return self.row.at(u16, offsets_6[self.at[0]]);
    }

    pub fn itemsInvolvedQty(self: @This()) u8 {
        return self.row.at(u8, offsets_7[self.at[0]]);
    }

    pub fn itemDropRate(self: @This()) u8 {
        return self.row.at(u8, offsets_8[self.at[0]]);
    }

    pub const num_of_appearance_len = 8;
    pub fn numOfAppearance(self: @This(), n1: usize) u8 {
        return self.row.at(u8, offsets_9[self.at[0]][n1]);
    }
};

pub const to_do_sequence_len = 8;
pub fn toDoSequence(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_10[n0]);
}

/// Links to `CompanyLeveRule`.
pub fn rule(self: @This()) excel.Link(sheets.CompanyLeveRule) {
    return .of(self.row.at(i32, 408));
}

pub fn ruleParam(self: @This()) u8 {
    return self.row.at(u8, 412);
}

const offsets_1 = [8]u16{ 0, 2, 4, 6, 8, 10, 12, 14 };
const offsets_2 = [8]u16{ 16, 64, 112, 160, 208, 256, 304, 352 };
const offsets_3 = [8][6]u16{ .{ 20, 24, 28, 32, 36, 40 }, .{ 68, 72, 76, 80, 84, 88 }, .{ 116, 120, 124, 128, 132, 136 }, .{ 164, 168, 172, 176, 180, 184 }, .{ 212, 216, 220, 224, 228, 232 }, .{ 260, 264, 268, 272, 276, 280 }, .{ 308, 312, 316, 320, 324, 328 }, .{ 356, 360, 364, 368, 372, 376 } };
const offsets_4 = [8]u16{ 44, 92, 140, 188, 236, 284, 332, 380 };
const offsets_5 = [8]u16{ 48, 96, 144, 192, 240, 288, 336, 384 };
const offsets_6 = [8]u16{ 52, 100, 148, 196, 244, 292, 340, 388 };
const offsets_7 = [8]u16{ 54, 102, 150, 198, 246, 294, 342, 390 };
const offsets_8 = [8]u16{ 55, 103, 151, 199, 247, 295, 343, 391 };
const offsets_9 = [8][8]u16{ .{ 56, 57, 58, 59, 60, 61, 62, 63 }, .{ 104, 105, 106, 107, 108, 109, 110, 111 }, .{ 152, 153, 154, 155, 156, 157, 158, 159 }, .{ 200, 201, 202, 203, 204, 205, 206, 207 }, .{ 248, 249, 250, 251, 252, 253, 254, 255 }, .{ 296, 297, 298, 299, 300, 301, 302, 303 }, .{ 344, 345, 346, 347, 348, 349, 350, 351 }, .{ 392, 393, 394, 395, 396, 397, 398, 399 } };
const offsets_10 = [8]u16{ 400, 401, 402, 403, 404, 405, 406, 407 };
