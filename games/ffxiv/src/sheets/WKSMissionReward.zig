//! `WKSMissionReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionReward = @This();

pub const sheet_name = "WKSMissionReward";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x433851d5;
pub const Sheet = excel.Typed(WKSMissionReward);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ExpModifier[0]", "ExpModifier[1]", "ExpModifier[2]", "CosmoCredits", "PlanetCredits", "BaseDronebits", "Unknown19", "Tool[0]", "TypeIndex[0]", "ResearchReward[0]", "Tool[1]", "TypeIndex[1]", "ResearchReward[1]", "Tool[2]", "TypeIndex[2]", "ResearchReward[2]", "Item", "ItemCount" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub const exp_modifier_len = 3;
/// ExpReward = ExpToNex * (lvl < 50 ? ExpModifier[0] : lvl < 90 ? ExpModifier[1] : ExpModifier[2]) / 100
pub fn expModifier(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_1[n0]);
}

pub fn cosmoCredits(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn planetCredits(self: @This()) u16 {
    return self.row.at(u16, 12);
}

/// Doesn't take Gold bonus in to account
pub fn baseDronebits(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub const research_reward_len = 3;
pub fn researchReward(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

pub fn itemCount(self: @This()) u16 {
    return self.row.at(u16, 22);
}

/// Needs to match WKSEmergencyProblem.Unknown2 to be active?
pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub const tool_len = 3;
/// Links to `WKSCosmoToolClass`.
pub fn tool(self: @This(), n0: usize) excel.Link(sheets.WKSCosmoToolClass) {
    return .of(self.row.at(u8, offsets_3[n0]));
}

pub const type_index_len = 3;
pub fn typeIndex(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_4[n0]);
}

const offsets_1 = [3]u16{ 4, 6, 8 };
const offsets_2 = [3]u16{ 16, 18, 20 };
const offsets_3 = [3]u16{ 25, 26, 27 };
const offsets_4 = [3]u16{ 28, 29, 30 };
