//! `SatisfactionNpc`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Npc`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SatisfactionNpc = @This();

pub const sheet_name = "SatisfactionNpc";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5527b648;
pub const Sheet = excel.Typed(SatisfactionNpc);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Npc", "QuestRequired", "LevelUnlock", "DeliveriesPerWeek", "SatisfactionNpcParams[0].SupplyIndex", "SatisfactionNpcParams[1].SupplyIndex", "SatisfactionNpcParams[2].SupplyIndex", "SatisfactionNpcParams[3].SupplyIndex", "SatisfactionNpcParams[4].SupplyIndex", "SatisfactionNpcParams[5].SupplyIndex", "SatisfactionNpcParams[0].SatisfactionRequired", "SatisfactionNpcParams[1].SatisfactionRequired", "SatisfactionNpcParams[2].SatisfactionRequired", "SatisfactionNpcParams[3].SatisfactionRequired", "SatisfactionNpcParams[4].SatisfactionRequired", "SatisfactionNpcParams[5].SatisfactionRequired", "SatisfactionNpcParams[0].Item[0]", "SatisfactionNpcParams[1].Item[0]", "SatisfactionNpcParams[2].Item[0]", "SatisfactionNpcParams[3].Item[0]", "SatisfactionNpcParams[4].Item[0]", "SatisfactionNpcParams[5].Item[0]", "SatisfactionNpcParams[0].ItemCount[0]", "SatisfactionNpcParams[1].ItemCount[0]", "SatisfactionNpcParams[2].ItemCount[0]", "SatisfactionNpcParams[3].ItemCount[0]", "SatisfactionNpcParams[4].ItemCount[0]", "SatisfactionNpcParams[5].ItemCount[0]", "SatisfactionNpcParams[0].IsHQ[0]", "SatisfactionNpcParams[1].IsHQ[0]", "SatisfactionNpcParams[2].IsHQ[0]", "SatisfactionNpcParams[3].IsHQ[0]", "SatisfactionNpcParams[4].IsHQ[0]", "SatisfactionNpcParams[5].IsHQ[0]", "SatisfactionNpcParams[0].Item[1]", "SatisfactionNpcParams[1].Item[1]", "SatisfactionNpcParams[2].Item[1]", "SatisfactionNpcParams[3].Item[1]", "SatisfactionNpcParams[4].Item[1]", "SatisfactionNpcParams[5].Item[1]", "SatisfactionNpcParams[0].ItemCount[1]", "SatisfactionNpcParams[1].ItemCount[1]", "SatisfactionNpcParams[2].ItemCount[1]", "SatisfactionNpcParams[3].ItemCount[1]", "SatisfactionNpcParams[4].ItemCount[1]", "SatisfactionNpcParams[5].ItemCount[1]", "SatisfactionNpcParams[0].IsHQ[1]", "SatisfactionNpcParams[1].IsHQ[1]", "SatisfactionNpcParams[2].IsHQ[1]", "SatisfactionNpcParams[3].IsHQ[1]", "SatisfactionNpcParams[4].IsHQ[1]", "SatisfactionNpcParams[5].IsHQ[1]", "SatisfactionNpcParams[0].Item[2]", "SatisfactionNpcParams[1].Item[2]", "SatisfactionNpcParams[2].Item[2]", "SatisfactionNpcParams[3].Item[2]", "SatisfactionNpcParams[4].Item[2]", "SatisfactionNpcParams[5].Item[2]", "SatisfactionNpcParams[0].ItemCount[2]", "SatisfactionNpcParams[1].ItemCount[2]", "SatisfactionNpcParams[2].ItemCount[2]", "SatisfactionNpcParams[3].ItemCount[2]", "SatisfactionNpcParams[4].ItemCount[2]", "SatisfactionNpcParams[5].ItemCount[2]", "SatisfactionNpcParams[0].IsHQ[2]", "SatisfactionNpcParams[1].IsHQ[2]", "SatisfactionNpcParams[2].IsHQ[2]", "SatisfactionNpcParams[3].IsHQ[2]", "SatisfactionNpcParams[4].IsHQ[2]", "SatisfactionNpcParams[5].IsHQ[2]", "RankParams[0].ImageId", "RankParams[1].ImageId", "RankParams[2].ImageId", "RankParams[3].ImageId", "RankParams[4].ImageId", "RankParams[5].ImageId", "RankParams[0].Unknown1", "RankParams[1].Unknown1", "RankParams[2].Unknown1", "RankParams[3].Unknown1", "RankParams[4].Unknown1", "RankParams[5].Unknown1", "RankParams[0].Quest", "RankParams[1].Quest", "RankParams[2].Quest", "RankParams[3].Quest", "RankParams[4].Quest", "RankParams[5].Quest", "Level", "Icon", "GlamourIndex", "Unknown19", "Unknown20" };

pub const satisfaction_npc_params_len = 6;
pub fn satisfactionNpcParams(self: @This(), n0: usize) SatisfactionNpcParamsEntry {
    std.debug.assert(n0 < 6);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const SatisfactionNpcParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    pub fn supplyIndex(self: @This()) i32 {
        return self.row.at(i32, offsets_1[self.at[0]]);
    }

    pub const item_len = 3;
    /// Links to `Item`.
    pub fn item(self: @This(), n1: usize) excel.Link(sheets.Item) {
        return .of(self.row.at(i32, offsets_2[self.at[0]][n1]));
    }

    pub fn satisfactionRequired(self: @This()) u16 {
        return self.row.at(u16, offsets_3[self.at[0]]);
    }

    pub const item_count_len = 3;
    pub fn itemCount(self: @This(), n1: usize) u8 {
        return self.row.at(u8, offsets_4[self.at[0]][n1]);
    }

    pub const is_hq_len = 3;
    pub fn isHQ(self: @This(), n1: usize) bool {
        return self.row.at(u8, offsets_5[self.at[0]][n1]) != 0;
    }
};

pub const rank_params_len = 6;
pub fn rankParams(self: @This(), n0: usize) RankParamsEntry {
    std.debug.assert(n0 < 6);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const RankParamsEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
    pub fn imageId(self: @This()) i32 {
        return self.row.at(i32, offsets_6[self.at[0]]);
    }

    pub fn unknown1(self: @This()) i32 {
        return self.row.at(i32, offsets_7[self.at[0]]);
    }

    /// Links to `Quest`.
    pub fn quest(self: @This()) excel.Link(sheets.Quest) {
        return .of(self.row.at(i32, offsets_8[self.at[0]]));
    }
};

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 216));
}

/// Links to `ENpcResident`.
pub fn npc(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(i32, 220));
}

/// Links to `Quest`.
pub fn questRequired(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 224));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 228);
}

pub fn levelUnlock(self: @This()) u8 {
    return self.row.at(u8, 232);
}

pub fn deliveriesPerWeek(self: @This()) u8 {
    return self.row.at(u8, 233);
}

pub fn glamourIndex(self: @This()) u8 {
    return self.row.at(u8, 234);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 235);
}

pub fn unknown20(self: @This()) u8 {
    return self.row.at(u8, 236);
}

const offsets_1 = [6]u16{ 0, 24, 48, 72, 96, 120 };
const offsets_2 = [6][3]u16{ .{ 4, 8, 12 }, .{ 28, 32, 36 }, .{ 52, 56, 60 }, .{ 76, 80, 84 }, .{ 100, 104, 108 }, .{ 124, 128, 132 } };
const offsets_3 = [6]u16{ 16, 40, 64, 88, 112, 136 };
const offsets_4 = [6][3]u16{ .{ 18, 19, 20 }, .{ 42, 43, 44 }, .{ 66, 67, 68 }, .{ 90, 91, 92 }, .{ 114, 115, 116 }, .{ 138, 139, 140 } };
const offsets_5 = [6][3]u16{ .{ 21, 22, 23 }, .{ 45, 46, 47 }, .{ 69, 70, 71 }, .{ 93, 94, 95 }, .{ 117, 118, 119 }, .{ 141, 142, 143 } };
const offsets_6 = [6]u16{ 144, 156, 168, 180, 192, 204 };
const offsets_7 = [6]u16{ 148, 160, 172, 184, 196, 208 };
const offsets_8 = [6]u16{ 152, 164, 176, 188, 200, 212 };
