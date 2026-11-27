//! `WKSMissionUnit`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionUnit = @This();

pub const sheet_name = "WKSMissionUnit";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5698ae07;
pub const Sheet = excel.Typed(WKSMissionUnit);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "WKSMissionText", "ClassJobCategory[0]", "ClassJobCategory[1]", "WKSFunction", "IsSpecialQuest", "Unknown2", "Unknown1", "LevelGroup", "MissionTime", "MissionReward", "SilverStarRequirement", "GoldStarRequirement", "MissionToDo[0]", "MissionToDo[1]", "MissionToDo[2]", "MissionLotteryCond", "WKSMissionLotterySpecialCond", "LockedBehind", "WKSMissionSupplyItem", "IsSynced", "WKSMissionRecipe", "PlaceName", "SortKey" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn silverStarRequirement(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn goldStarRequirement(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// Links to `WKSMissionText`.
pub fn wksMissionText(self: @This()) excel.Link(sheets.WKSMissionText) {
    return .of(self.row.at(u16, 12));
}

pub const class_job_category_len = 2;
/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This(), n0: usize) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn missionTime(self: @This()) u16 {
    return self.row.at(u16, 20);
}

/// Links to `WKSMissionReward`.
pub fn missionReward(self: @This()) excel.Link(sheets.WKSMissionReward) {
    return .of(self.row.at(u16, 22));
}

pub const mission_to_do_len = 3;
/// Links to `WKSMissionToDo`.
pub fn missionToDo(self: @This(), n0: usize) excel.Link(sheets.WKSMissionToDo) {
    return .of(self.row.at(u16, offsets_2[n0]));
}

/// Links to `WKSMissionUnit`.
pub fn lockedBehind(self: @This()) excel.Link(sheets.WKSMissionUnit) {
    return .of(self.row.at(u16, 30));
}

/// Links to `WKSMissionSupplyItem`.
pub fn wksMissionSupplyItem(self: @This()) excel.Link(sheets.WKSMissionSupplyItem) {
    return .of(self.row.at(u16, 32));
}

/// Links to `WKSMissionRecipe`.
pub fn wksMissionRecipe(self: @This()) excel.Link(sheets.WKSMissionRecipe) {
    return .of(self.row.at(u16, 34));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 36));
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 38);
}

/// Links to `WKSFunction`.
pub fn wksFunction(self: @This()) excel.Link(sheets.WKSFunction) {
    return .of(self.row.at(u8, 40));
}

pub fn levelGroup(self: @This()) u8 {
    return self.row.at(u8, 41);
}

/// Links to `WKSMissionLotteryCond`.
pub fn missionLotteryCond(self: @This()) excel.Link(sheets.WKSMissionLotteryCond) {
    return .of(self.row.at(u8, 42));
}

/// Links to `WKSMissionLotterySpecialCond`.
pub fn wksMissionLotterySpecialCond(self: @This()) excel.Link(sheets.WKSMissionLotterySpecialCond) {
    return .of(self.row.at(u8, 43));
}

pub fn isSynced(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn isSpecialQuest(self: @This()) bool {
    return self.row.bitAt(45, 0);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(45, 1);
}

const offsets_1 = [2]u16{ 14, 16 };
const offsets_2 = [3]u16{ 24, 26, 28 };
