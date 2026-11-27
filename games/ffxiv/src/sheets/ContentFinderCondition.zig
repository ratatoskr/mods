//! `ContentFinderCondition`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentFinderCondition = @This();

pub const sheet_name = "ContentFinderCondition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xaa5f7849;
pub const Sheet = excel.Typed(ContentFinderCondition);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ShortCode", "TerritoryType", "ContentLinkType", "Content", "PvP", "Unknown_70_2", "RequiredExVersion", "Unknown29", "ContentCloseCycle", "AcceptClassJobCategory", "ContentMemberType", "Unknown34", "QueueMaxPlayers", "UnlockType", "UnlockCriteria", "UnlockType2", "UnlockCriteria2", "ClassJobLevelRequired", "ClassJobLevelSync", "ItemLevelRequired", "ItemLevelSync", "FixedItemLevelSync", "AllowUndersized", "NeedsMemberInEveryParty", "Unknown57", "AllowReplacement", "AllowMinimumIL", "AllowExplorerMode", "RatedMatch", "Rated", "LootModeType", "Unknown47", "IsInDutyFinder", "HighEndDuty", "Unknown49", "RaidFinderParam", "HasOnePlayerPerJobDetails", "Unknown51", "DutyRecorderAllowed", "Unknown52", "IsRegistrationHomeWorldLimited", "Unknown54", "Unknown55", "Name", "NameShort", "ContentType", "ContentUICategory", "JournalGenre", "Unknown59", "SortKey", "Image", "Icon", "Unknown41", "Unknown32", "Unknown56", "IsRegistrationAllowedFromAnyDataCenter", "Unknown58", "PenaltyTimestampArrayIndex", "LevelingRoulette", "HighLevelRoulette", "MSQRoulette", "GuildHestRoulette", "ExpertRoulette", "TrialRoulette", "DailyFrontlineChallenge", "LevelCapRoulette", "MentorRoulette", "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "AllianceRoulette", "FeastTeamRoulette", "NormalRaidRoulette", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14", "Unknown15", "Unknown16", "Unknown17", "Unknown18", "Unknown19", "Unknown20", "Unknown21", "Unknown22", "Unknown23", "Unknown24", "Unknown25", "Unknown26", "CrystallineConflictCasualRoulette", "CrystallineConflictRankedRoulette" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn nameShort(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn levelingRoulette(self: @This()) bool {
    return self.row.at(u8, 8) != 0;
}

pub fn highLevelRoulette(self: @This()) bool {
    return self.row.at(u8, 9) != 0;
}

pub fn msqRoulette(self: @This()) bool {
    return self.row.at(u8, 10) != 0;
}

pub fn guildHestRoulette(self: @This()) bool {
    return self.row.at(u8, 11) != 0;
}

pub fn expertRoulette(self: @This()) bool {
    return self.row.at(u8, 12) != 0;
}

pub fn trialRoulette(self: @This()) bool {
    return self.row.at(u8, 13) != 0;
}

pub fn dailyFrontlineChallenge(self: @This()) bool {
    return self.row.at(u8, 14) != 0;
}

pub fn levelCapRoulette(self: @This()) bool {
    return self.row.at(u8, 15) != 0;
}

pub fn mentorRoulette(self: @This()) bool {
    return self.row.at(u8, 16) != 0;
}

pub fn unknown0(self: @This()) bool {
    return self.row.at(u8, 17) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 18) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 19) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 20) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 21) != 0;
}

pub fn allianceRoulette(self: @This()) bool {
    return self.row.at(u8, 22) != 0;
}

pub fn feastTeamRoulette(self: @This()) bool {
    return self.row.at(u8, 23) != 0;
}

pub fn normalRaidRoulette(self: @This()) bool {
    return self.row.at(u8, 24) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 25) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 26) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 27) != 0;
}

pub fn unknown8(self: @This()) bool {
    return self.row.at(u8, 28) != 0;
}

pub fn unknown9(self: @This()) bool {
    return self.row.at(u8, 29) != 0;
}

pub fn unknown10(self: @This()) bool {
    return self.row.at(u8, 30) != 0;
}

pub fn unknown11(self: @This()) bool {
    return self.row.at(u8, 31) != 0;
}

pub fn unknown12(self: @This()) bool {
    return self.row.at(u8, 32) != 0;
}

pub fn unknown13(self: @This()) bool {
    return self.row.at(u8, 33) != 0;
}

pub fn unknown14(self: @This()) bool {
    return self.row.at(u8, 34) != 0;
}

pub fn unknown15(self: @This()) bool {
    return self.row.at(u8, 35) != 0;
}

pub fn unknown16(self: @This()) bool {
    return self.row.at(u8, 36) != 0;
}

pub fn unknown17(self: @This()) bool {
    return self.row.at(u8, 37) != 0;
}

pub fn unknown18(self: @This()) bool {
    return self.row.at(u8, 38) != 0;
}

pub fn unknown19(self: @This()) bool {
    return self.row.at(u8, 39) != 0;
}

pub fn unknown20(self: @This()) bool {
    return self.row.at(u8, 40) != 0;
}

pub fn unknown21(self: @This()) bool {
    return self.row.at(u8, 41) != 0;
}

pub fn unknown22(self: @This()) bool {
    return self.row.at(u8, 42) != 0;
}

pub fn unknown23(self: @This()) bool {
    return self.row.at(u8, 43) != 0;
}

pub fn unknown24(self: @This()) bool {
    return self.row.at(u8, 44) != 0;
}

pub fn unknown25(self: @This()) bool {
    return self.row.at(u8, 45) != 0;
}

pub fn unknown26(self: @This()) bool {
    return self.row.at(u8, 46) != 0;
}

pub fn crystallineConflictCasualRoulette(self: @This()) bool {
    return self.row.at(u8, 47) != 0;
}

pub fn crystallineConflictRankedRoulette(self: @This()) bool {
    return self.row.at(u8, 48) != 0;
}

pub fn shortCode(self: @This()) []const u8 {
    return self.row.stringAt(52);
}

/// This would show Addon#102618, if not 0, but the row is empty.
pub fn unknown29(self: @This()) u32 {
    return self.row.at(u32, 56);
}

/// Links to `ContentCloseCycle`.
pub fn contentCloseCycle(self: @This()) excel.Link(sheets.ContentCloseCycle) {
    return .of(self.row.at(u32, 60));
}

/// Links by `UnlockType`: 1 to `Quest`, 2 to `InstanceContent`.
pub fn unlockCriteria(self: @This()) u32 {
    return self.row.at(u32, 64);
}

/// Links by `UnlockType2`: 1 to `Quest`, 2 to `InstanceContent`.
pub fn unlockCriteria2(self: @This()) u32 {
    return self.row.at(u32, 68);
}

/// Links to `JournalGenre`.
pub fn journalGenre(self: @This()) excel.Link(sheets.JournalGenre) {
    return .of(self.row.at(u32, 72));
}

pub fn unknown59(self: @This()) u32 {
    return self.row.at(u32, 76);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 80);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 84);
}

pub fn unknown32(self: @This()) i32 {
    return self.row.at(i32, 88);
}

pub fn unknown58(self: @This()) i32 {
    return self.row.at(i32, 92);
}

/// Links to `TerritoryType`.
pub fn territoryType(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 96));
}

/// Links by `ContentLinkType`: 1 to `InstanceContent`, 2 to `PartyContent`, 3 to `PublicContent`, 4 to `GoldSaucerContent`, 5 to `QuestBattle`.
pub fn content(self: @This()) u16 {
    return self.row.at(u16, 98);
}

pub fn itemLevelRequired(self: @This()) u16 {
    return self.row.at(u16, 100);
}

pub fn itemLevelSync(self: @This()) u16 {
    return self.row.at(u16, 102);
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 104);
}

pub fn contentLinkType(self: @This()) u8 {
    return self.row.at(u8, 106);
}

/// Links to `ExVersion`.
pub fn requiredExVersion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 107));
}

/// Links to `ClassJobCategory`.
pub fn acceptClassJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 108));
}

/// Links to `ContentMemberType`.
pub fn contentMemberType(self: @This()) excel.Link(sheets.ContentMemberType) {
    return .of(self.row.at(u8, 109));
}

/// Used to control what is displayed as player count (Addon#10806, Addon#10805, etc.). Has some weird logic behind it.
pub fn unknown34(self: @This()) u8 {
    return self.row.at(u8, 110);
}

pub fn queueMaxPlayers(self: @This()) u8 {
    return self.row.at(u8, 111);
}

pub fn unlockType(self: @This()) u8 {
    return self.row.at(u8, 112);
}

pub fn unlockType2(self: @This()) u8 {
    return self.row.at(u8, 113);
}

pub fn classJobLevelRequired(self: @This()) u8 {
    return self.row.at(u8, 114);
}

pub fn classJobLevelSync(self: @This()) u8 {
    return self.row.at(u8, 115);
}

/// Links to `LootModeType`.
pub fn lootModeType(self: @This()) excel.Link(sheets.LootModeType) {
    return .of(self.row.at(u8, 116));
}

/// Links to `RaidFinderParam`.
pub fn raidFinderParam(self: @This()) excel.Link(sheets.RaidFinderParam) {
    return .of(self.row.at(u8, 117));
}

/// Links to `ContentType`.
pub fn contentType(self: @This()) excel.Link(sheets.ContentType) {
    return .of(self.row.at(u8, 118));
}

/// Links to `ContentUICategory`.
pub fn contentUICategory(self: @This()) excel.Link(sheets.ContentUICategory) {
    return .of(self.row.at(u8, 119));
}

/// Index in PlayerState.PenaltyTimestamps
pub fn penaltyTimestampArrayIndex(self: @This()) u8 {
    return self.row.at(u8, 120);
}

pub fn unknown41(self: @This()) i8 {
    return self.row.at(i8, 121);
}

pub fn pvP(self: @This()) bool {
    return self.row.bitAt(122, 0);
}

pub fn unknown_70_2(self: @This()) bool {
    return self.row.bitAt(122, 1);
}

/// If true, the players item level is always set to ItemLevelSync (up-sync and down-sync possible).
pub fn fixedItemLevelSync(self: @This()) bool {
    return self.row.bitAt(122, 2);
}

pub fn allowUndersized(self: @This()) bool {
    return self.row.bitAt(122, 3);
}

pub fn needsMemberInEveryParty(self: @This()) bool {
    return self.row.bitAt(122, 4);
}

pub fn unknown57(self: @This()) bool {
    return self.row.bitAt(122, 5);
}

pub fn allowReplacement(self: @This()) bool {
    return self.row.bitAt(122, 6);
}

pub fn allowMinimumIL(self: @This()) bool {
    return self.row.bitAt(122, 7);
}

pub fn allowExplorerMode(self: @This()) bool {
    return self.row.bitAt(123, 0);
}

pub fn ratedMatch(self: @This()) bool {
    return self.row.bitAt(123, 1);
}

pub fn rated(self: @This()) bool {
    return self.row.bitAt(123, 2);
}

pub fn unknown47(self: @This()) bool {
    return self.row.bitAt(123, 3);
}

pub fn isInDutyFinder(self: @This()) bool {
    return self.row.bitAt(123, 4);
}

pub fn highEndDuty(self: @This()) bool {
    return self.row.bitAt(123, 5);
}

pub fn unknown49(self: @This()) bool {
    return self.row.bitAt(123, 6);
}

pub fn hasOnePlayerPerJobDetails(self: @This()) bool {
    return self.row.bitAt(123, 7);
}

pub fn unknown51(self: @This()) bool {
    return self.row.bitAt(124, 0);
}

pub fn dutyRecorderAllowed(self: @This()) bool {
    return self.row.bitAt(124, 1);
}

pub fn unknown52(self: @This()) bool {
    return self.row.bitAt(124, 2);
}

pub fn isRegistrationHomeWorldLimited(self: @This()) bool {
    return self.row.bitAt(124, 3);
}

pub fn unknown54(self: @This()) bool {
    return self.row.bitAt(124, 4);
}

pub fn unknown55(self: @This()) bool {
    return self.row.bitAt(124, 5);
}

pub fn unknown56(self: @This()) bool {
    return self.row.bitAt(124, 6);
}

pub fn isRegistrationAllowedFromAnyDataCenter(self: @This()) bool {
    return self.row.bitAt(124, 7);
}
