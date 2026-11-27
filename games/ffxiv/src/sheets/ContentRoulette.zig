//! `ContentRoulette`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentRoulette = @This();

pub const sheet_name = "ContentRoulette";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x45e13ce2;
pub const Sheet = excel.Typed(ContentRoulette);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Category", "Unknown0", "Description", "DutyType", "RequiredExVersion", "Unknown1", "IsGoldSaucer", "IsInDutyFinder", "OpenRule", "IsPvP", "RequiredLevel", "SyncedFromLevel", "ItemLevelRequired", "AppliesHighestAverageDutyItemLevel", "ItemLevelSync", "Image", "ContentRouletteRoleBonus", "RewardTomeA", "RewardTomeB", "RewardTomeC", "RewardPvPExp", "RewardWolfMarks", "RewardSeriesExp", "SortKey", "ClassJobCategory", "ContentMemberType", "Unknown9", "QueueMaxPlayers", "CompletionArrayIndex", "Unknown18", "ContentType", "UICategory", "TimeLimit", "TimeLimitMax", "AllowConsumableItems", "AllowPhoenixDown", "AllowReplacement", "RatedMatch", "Rated", "LootModeType", "InstanceContent", "Unknown22", "Unknown15", "Unknown23", "Unknown24", "IsRegistrationAllowedFromAnyDataCenter", "Region", "PenaltyTimestampArrayIndex" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn category(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn dutyType(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

/// This would show Addon#102618, but the row is empty.
pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn rewardPvPExp(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn rewardSeriesExp(self: @This()) u32 {
    return self.row.at(u32, 32);
}

/// Links to `ContentFinderConditionRegion`.
pub fn region(self: @This()) excel.Link(sheets.ContentFinderConditionRegion) {
    return .of(self.row.at(i32, 36));
}

pub fn itemLevelRequired(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn itemLevelSync(self: @This()) u16 {
    return self.row.at(u16, 42);
}

pub fn rewardTomeA(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn rewardTomeB(self: @This()) u16 {
    return self.row.at(u16, 46);
}

pub fn rewardTomeC(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn rewardWolfMarks(self: @This()) u16 {
    return self.row.at(u16, 50);
}

/// Links to `InstanceContent`.
pub fn instanceContent(self: @This()) excel.Link(sheets.InstanceContent) {
    return .of(self.row.at(u16, 52));
}

/// Links to `ExVersion`.
pub fn requiredExVersion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 54));
}

/// Links to `ContentRouletteOpenRule`.
pub fn openRule(self: @This()) excel.Link(sheets.ContentRouletteOpenRule) {
    return .of(self.row.at(u8, 55));
}

pub fn requiredLevel(self: @This()) u8 {
    return self.row.at(u8, 56);
}

pub fn syncedFromLevel(self: @This()) u8 {
    return self.row.at(u8, 57);
}

/// Links to `ContentRouletteRoleBonus`.
pub fn contentRouletteRoleBonus(self: @This()) excel.Link(sheets.ContentRouletteRoleBonus) {
    return .of(self.row.at(u8, 58));
}

pub fn sortKey(self: @This()) u8 {
    return self.row.at(u8, 59);
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 60));
}

/// Links to `ContentMemberType`.
pub fn contentMemberType(self: @This()) excel.Link(sheets.ContentMemberType) {
    return .of(self.row.at(u8, 61));
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 62);
}

pub fn queueMaxPlayers(self: @This()) u8 {
    return self.row.at(u8, 63);
}

/// Links to `ContentType`.
pub fn contentType(self: @This()) excel.Link(sheets.ContentType) {
    return .of(self.row.at(u8, 64));
}

/// Links to `ContentUICategory`.
pub fn uiCategory(self: @This()) excel.Link(sheets.ContentUICategory) {
    return .of(self.row.at(u8, 65));
}

/// In minutes.
pub fn timeLimit(self: @This()) u8 {
    return self.row.at(u8, 66);
}

/// In minutes. If 0, only TimeLimit is displayed.
pub fn timeLimitMax(self: @This()) u8 {
    return self.row.at(u8, 67);
}

/// Links to `LootModeType`.
pub fn lootModeType(self: @This()) excel.Link(sheets.LootModeType) {
    return .of(self.row.at(u8, 68));
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 69);
}

/// Index in PlayerState.PenaltyTimestamps
pub fn penaltyTimestampArrayIndex(self: @This()) u8 {
    return self.row.at(u8, 70);
}

/// Index in PlayerState.ContentRouletteCompletion
pub fn completionArrayIndex(self: @This()) i8 {
    return self.row.at(i8, 71);
}

pub fn isGoldSaucer(self: @This()) bool {
    return self.row.bitAt(72, 0);
}

pub fn isInDutyFinder(self: @This()) bool {
    return self.row.bitAt(72, 1);
}

pub fn isPvP(self: @This()) bool {
    return self.row.bitAt(72, 2);
}

/// Displays Addon#2828.
pub fn appliesHighestAverageDutyItemLevel(self: @This()) bool {
    return self.row.bitAt(72, 3);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(72, 4);
}

pub fn allowConsumableItems(self: @This()) bool {
    return self.row.bitAt(72, 5);
}

pub fn allowPhoenixDown(self: @This()) bool {
    return self.row.bitAt(72, 6);
}

pub fn allowReplacement(self: @This()) bool {
    return self.row.bitAt(72, 7);
}

pub fn ratedMatch(self: @This()) bool {
    return self.row.bitAt(73, 0);
}

pub fn rated(self: @This()) bool {
    return self.row.bitAt(73, 1);
}

/// This would show Addon#10833, but the row does not exist.
pub fn unknown22(self: @This()) bool {
    return self.row.bitAt(73, 2);
}

pub fn unknown23(self: @This()) bool {
    return self.row.bitAt(73, 3);
}

pub fn unknown24(self: @This()) bool {
    return self.row.bitAt(73, 4);
}

pub fn isRegistrationAllowedFromAnyDataCenter(self: @This()) bool {
    return self.row.bitAt(73, 5);
}
