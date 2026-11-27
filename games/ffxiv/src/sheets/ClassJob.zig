//! `ClassJob`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ClassJob = @This();

pub const sheet_name = "ClassJob";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa540f082;
pub const Sheet = excel.Typed(ClassJob);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Abbreviation", "NameFemale", "ClassJobCategory", "ExpArrayIndex", "BattleClassIndex", "Unknown8", "JobIndex", "DohDolJobIndex", "ModifierHitPoints", "ModifierManaPoints", "ModifierStrength", "ModifierVitality", "ModifierDexterity", "ModifierIntelligence", "ModifierMind", "ModifierPiety", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "ReplaceAction", "ReplaceActionPvP", "Unknown9", "PvPBaseParamValue", "PvPActionSortRow", "PvPInitialSelectActionTrait", "ClassJobParent", "NameEnglish", "ItemStartingWeaponMainHand", "ItemStartingWeaponOffHand", "Role", "StartingTown", "MonsterNote", "PrimaryStat", "LimitBreak1", "LimitBreak2", "LimitBreak3", "UIPriority", "ItemSoulCrystal", "UnlockQuest", "RelicQuest", "Prerequisite", "StartingLevel", "PartyBonus", "JobType", "IsLimitedJob", "CanWearShield", "CanQueueForDuty" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn abbreviation(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn nameFemale(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn canQueueForDuty(self: @This()) bool {
    return self.row.bitAt(12, 0);
}

pub fn nameEnglish(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

/// Links to `Item`.
pub fn itemSoulCrystal(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 20));
}

/// Links to `Quest`.
pub fn unlockQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 24));
}

/// Links to `Quest`.
pub fn relicQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 28));
}

/// Links to `Quest`.
pub fn prerequisite(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 32));
}

/// Links to `ReplaceAction`.
pub fn replaceAction(self: @This()) excel.Link(sheets.ReplaceAction) {
    return .of(self.row.at(i32, 36));
}

/// Links to `ReplaceAction`.
pub fn replaceActionPvP(self: @This()) excel.Link(sheets.ReplaceAction) {
    return .of(self.row.at(i32, 40));
}

pub fn unknown9(self: @This()) i32 {
    return self.row.at(i32, 44);
}

/// Links to `Item`.
pub fn itemStartingWeaponMainHand(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 48));
}

/// Links to `Item`.
pub fn itemStartingWeaponOffHand(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 52));
}

pub fn modifierHitPoints(self: @This()) u16 {
    return self.row.at(u16, 56);
}

pub fn modifierManaPoints(self: @This()) u16 {
    return self.row.at(u16, 58);
}

pub fn modifierStrength(self: @This()) u16 {
    return self.row.at(u16, 60);
}

pub fn modifierVitality(self: @This()) u16 {
    return self.row.at(u16, 62);
}

pub fn modifierDexterity(self: @This()) u16 {
    return self.row.at(u16, 64);
}

pub fn modifierIntelligence(self: @This()) u16 {
    return self.row.at(u16, 66);
}

pub fn modifierMind(self: @This()) u16 {
    return self.row.at(u16, 68);
}

pub fn modifierPiety(self: @This()) u16 {
    return self.row.at(u16, 70);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 72);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 74);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 76);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 78);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 80);
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 82);
}

/// Links to `Action`.
pub fn limitBreak1(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 84));
}

/// Links to `Action`.
pub fn limitBreak2(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 86));
}

/// Links to `Action`.
pub fn limitBreak3(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 88));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 90));
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 91);
}

pub fn jobIndex(self: @This()) u8 {
    return self.row.at(u8, 92);
}

/// Links to `PvPBaseParamValue`.
pub fn pvPBaseParamValue(self: @This()) excel.Link(sheets.PvPBaseParamValue) {
    return .of(self.row.at(u8, 93));
}

pub fn pvPActionSortRow(self: @This()) u8 {
    return self.row.at(u8, 94);
}

/// Links to `PvPInitialSelectActionTrait`.
pub fn pvPInitialSelectActionTrait(self: @This()) excel.Link(sheets.PvPInitialSelectActionTrait) {
    return .of(self.row.at(u8, 95));
}

/// Links to `ClassJob`.
pub fn classJobParent(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 96));
}

pub fn role(self: @This()) u8 {
    return self.row.at(u8, 97);
}

/// Links to `Town`.
pub fn startingTown(self: @This()) excel.Link(sheets.Town) {
    return .of(self.row.at(u8, 98));
}

pub fn primaryStat(self: @This()) u8 {
    return self.row.at(u8, 99);
}

pub fn uiPriority(self: @This()) u8 {
    return self.row.at(u8, 100);
}

pub fn startingLevel(self: @This()) u8 {
    return self.row.at(u8, 101);
}

pub fn partyBonus(self: @This()) u8 {
    return self.row.at(u8, 102);
}

/// 1 = Tank
/// 2 = Pure Healer
/// 3 = Melee
/// 4 = Physical Ranged
/// 5 = Magical Ranged
/// 6 = Barrier Healer
pub fn jobType(self: @This()) u8 {
    return self.row.at(u8, 103);
}

pub fn expArrayIndex(self: @This()) i8 {
    return self.row.at(i8, 104);
}

pub fn battleClassIndex(self: @This()) i8 {
    return self.row.at(i8, 105);
}

pub fn dohDolJobIndex(self: @This()) i8 {
    return self.row.at(i8, 106);
}

/// Links to `MonsterNote`.
pub fn monsterNote(self: @This()) excel.Link(sheets.MonsterNote) {
    return .of(self.row.at(i8, 107));
}

pub fn isLimitedJob(self: @This()) bool {
    return self.row.bitAt(108, 0);
}

pub fn canWearShield(self: @This()) bool {
    return self.row.bitAt(108, 1);
}
