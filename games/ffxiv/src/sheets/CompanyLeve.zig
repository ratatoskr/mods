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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "RoutePointTime[0]", "RoutePointTime[1]", "RoutePointTime[2]", "RoutePointTime[3]", "RoutePointTime[4]", "RoutePointTime[5]", "RoutePointTime[6]", "RoutePointTime[7]", "CompanyLeveStruct[0].BaseID", "CompanyLeveStruct[1].BaseID", "CompanyLeveStruct[2].BaseID", "CompanyLeveStruct[3].BaseID", "CompanyLeveStruct[4].BaseID", "CompanyLeveStruct[5].BaseID", "CompanyLeveStruct[6].BaseID", "CompanyLeveStruct[7].BaseID", "CompanyLeveStruct[0].EnemyLevel", "CompanyLeveStruct[1].EnemyLevel", "CompanyLeveStruct[2].EnemyLevel", "CompanyLeveStruct[3].EnemyLevel", "CompanyLeveStruct[4].EnemyLevel", "CompanyLeveStruct[5].EnemyLevel", "CompanyLeveStruct[6].EnemyLevel", "CompanyLeveStruct[7].EnemyLevel", "CompanyLeveStruct[0].BNpcName", "CompanyLeveStruct[1].BNpcName", "CompanyLeveStruct[2].BNpcName", "CompanyLeveStruct[3].BNpcName", "CompanyLeveStruct[4].BNpcName", "CompanyLeveStruct[5].BNpcName", "CompanyLeveStruct[6].BNpcName", "CompanyLeveStruct[7].BNpcName", "CompanyLeveStruct[0].ItemsInvolved", "CompanyLeveStruct[1].ItemsInvolved", "CompanyLeveStruct[2].ItemsInvolved", "CompanyLeveStruct[3].ItemsInvolved", "CompanyLeveStruct[4].ItemsInvolved", "CompanyLeveStruct[5].ItemsInvolved", "CompanyLeveStruct[6].ItemsInvolved", "CompanyLeveStruct[7].ItemsInvolved", "CompanyLeveStruct[0].ItemsInvolvedQty", "CompanyLeveStruct[1].ItemsInvolvedQty", "CompanyLeveStruct[2].ItemsInvolvedQty", "CompanyLeveStruct[3].ItemsInvolvedQty", "CompanyLeveStruct[4].ItemsInvolvedQty", "CompanyLeveStruct[5].ItemsInvolvedQty", "CompanyLeveStruct[6].ItemsInvolvedQty", "CompanyLeveStruct[7].ItemsInvolvedQty", "CompanyLeveStruct[0].ItemDropRate", "CompanyLeveStruct[1].ItemDropRate", "CompanyLeveStruct[2].ItemDropRate", "CompanyLeveStruct[3].ItemDropRate", "CompanyLeveStruct[4].ItemDropRate", "CompanyLeveStruct[5].ItemDropRate", "CompanyLeveStruct[6].ItemDropRate", "CompanyLeveStruct[7].ItemDropRate", "CompanyLeveStruct[0].ToDoParam[0]", "CompanyLeveStruct[1].ToDoParam[0]", "CompanyLeveStruct[2].ToDoParam[0]", "CompanyLeveStruct[3].ToDoParam[0]", "CompanyLeveStruct[4].ToDoParam[0]", "CompanyLeveStruct[5].ToDoParam[0]", "CompanyLeveStruct[6].ToDoParam[0]", "CompanyLeveStruct[7].ToDoParam[0]", "CompanyLeveStruct[0].ToDoParam[1]", "CompanyLeveStruct[1].ToDoParam[1]", "CompanyLeveStruct[2].ToDoParam[1]", "CompanyLeveStruct[3].ToDoParam[1]", "CompanyLeveStruct[4].ToDoParam[1]", "CompanyLeveStruct[5].ToDoParam[1]", "CompanyLeveStruct[6].ToDoParam[1]", "CompanyLeveStruct[7].ToDoParam[1]", "CompanyLeveStruct[0].ToDoParam[2]", "CompanyLeveStruct[1].ToDoParam[2]", "CompanyLeveStruct[2].ToDoParam[2]", "CompanyLeveStruct[3].ToDoParam[2]", "CompanyLeveStruct[4].ToDoParam[2]", "CompanyLeveStruct[5].ToDoParam[2]", "CompanyLeveStruct[6].ToDoParam[2]", "CompanyLeveStruct[7].ToDoParam[2]", "CompanyLeveStruct[0].ToDoParam[3]", "CompanyLeveStruct[1].ToDoParam[3]", "CompanyLeveStruct[2].ToDoParam[3]", "CompanyLeveStruct[3].ToDoParam[3]", "CompanyLeveStruct[4].ToDoParam[3]", "CompanyLeveStruct[5].ToDoParam[3]", "CompanyLeveStruct[6].ToDoParam[3]", "CompanyLeveStruct[7].ToDoParam[3]", "CompanyLeveStruct[0].ToDoParam[4]", "CompanyLeveStruct[1].ToDoParam[4]", "CompanyLeveStruct[2].ToDoParam[4]", "CompanyLeveStruct[3].ToDoParam[4]", "CompanyLeveStruct[4].ToDoParam[4]", "CompanyLeveStruct[5].ToDoParam[4]", "CompanyLeveStruct[6].ToDoParam[4]", "CompanyLeveStruct[7].ToDoParam[4]", "CompanyLeveStruct[0].ToDoParam[5]", "CompanyLeveStruct[1].ToDoParam[5]", "CompanyLeveStruct[2].ToDoParam[5]", "CompanyLeveStruct[3].ToDoParam[5]", "CompanyLeveStruct[4].ToDoParam[5]", "CompanyLeveStruct[5].ToDoParam[5]", "CompanyLeveStruct[6].ToDoParam[5]", "CompanyLeveStruct[7].ToDoParam[5]", "CompanyLeveStruct[0].NumOfAppearance[0]", "CompanyLeveStruct[1].NumOfAppearance[0]", "CompanyLeveStruct[2].NumOfAppearance[0]", "CompanyLeveStruct[3].NumOfAppearance[0]", "CompanyLeveStruct[4].NumOfAppearance[0]", "CompanyLeveStruct[5].NumOfAppearance[0]", "CompanyLeveStruct[6].NumOfAppearance[0]", "CompanyLeveStruct[7].NumOfAppearance[0]", "CompanyLeveStruct[0].NumOfAppearance[1]", "CompanyLeveStruct[1].NumOfAppearance[1]", "CompanyLeveStruct[2].NumOfAppearance[1]", "CompanyLeveStruct[3].NumOfAppearance[1]", "CompanyLeveStruct[4].NumOfAppearance[1]", "CompanyLeveStruct[5].NumOfAppearance[1]", "CompanyLeveStruct[6].NumOfAppearance[1]", "CompanyLeveStruct[7].NumOfAppearance[1]", "CompanyLeveStruct[0].NumOfAppearance[2]", "CompanyLeveStruct[1].NumOfAppearance[2]", "CompanyLeveStruct[2].NumOfAppearance[2]", "CompanyLeveStruct[3].NumOfAppearance[2]", "CompanyLeveStruct[4].NumOfAppearance[2]", "CompanyLeveStruct[5].NumOfAppearance[2]", "CompanyLeveStruct[6].NumOfAppearance[2]", "CompanyLeveStruct[7].NumOfAppearance[2]", "CompanyLeveStruct[0].NumOfAppearance[3]", "CompanyLeveStruct[1].NumOfAppearance[3]", "CompanyLeveStruct[2].NumOfAppearance[3]", "CompanyLeveStruct[3].NumOfAppearance[3]", "CompanyLeveStruct[4].NumOfAppearance[3]", "CompanyLeveStruct[5].NumOfAppearance[3]", "CompanyLeveStruct[6].NumOfAppearance[3]", "CompanyLeveStruct[7].NumOfAppearance[3]", "CompanyLeveStruct[0].NumOfAppearance[4]", "CompanyLeveStruct[1].NumOfAppearance[4]", "CompanyLeveStruct[2].NumOfAppearance[4]", "CompanyLeveStruct[3].NumOfAppearance[4]", "CompanyLeveStruct[4].NumOfAppearance[4]", "CompanyLeveStruct[5].NumOfAppearance[4]", "CompanyLeveStruct[6].NumOfAppearance[4]", "CompanyLeveStruct[7].NumOfAppearance[4]", "CompanyLeveStruct[0].NumOfAppearance[5]", "CompanyLeveStruct[1].NumOfAppearance[5]", "CompanyLeveStruct[2].NumOfAppearance[5]", "CompanyLeveStruct[3].NumOfAppearance[5]", "CompanyLeveStruct[4].NumOfAppearance[5]", "CompanyLeveStruct[5].NumOfAppearance[5]", "CompanyLeveStruct[6].NumOfAppearance[5]", "CompanyLeveStruct[7].NumOfAppearance[5]", "CompanyLeveStruct[0].NumOfAppearance[6]", "CompanyLeveStruct[1].NumOfAppearance[6]", "CompanyLeveStruct[2].NumOfAppearance[6]", "CompanyLeveStruct[3].NumOfAppearance[6]", "CompanyLeveStruct[4].NumOfAppearance[6]", "CompanyLeveStruct[5].NumOfAppearance[6]", "CompanyLeveStruct[6].NumOfAppearance[6]", "CompanyLeveStruct[7].NumOfAppearance[6]", "CompanyLeveStruct[0].NumOfAppearance[7]", "CompanyLeveStruct[1].NumOfAppearance[7]", "CompanyLeveStruct[2].NumOfAppearance[7]", "CompanyLeveStruct[3].NumOfAppearance[7]", "CompanyLeveStruct[4].NumOfAppearance[7]", "CompanyLeveStruct[5].NumOfAppearance[7]", "CompanyLeveStruct[6].NumOfAppearance[7]", "CompanyLeveStruct[7].NumOfAppearance[7]", "ToDoSequence[0]", "ToDoSequence[1]", "ToDoSequence[2]", "ToDoSequence[3]", "ToDoSequence[4]", "ToDoSequence[5]", "ToDoSequence[6]", "ToDoSequence[7]", "Rule", "RuleParam" };

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
