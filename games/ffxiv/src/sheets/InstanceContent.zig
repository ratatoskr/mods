//! `InstanceContent`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ContentFinderCondition`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InstanceContent = @This();

pub const sheet_name = "InstanceContent";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcf914c2d;
pub const Sheet = excel.Typed(InstanceContent);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "InstanceContentType", "WeekRestriction", "TimeLimitmin", "Unknown14", "BGM", "WinBGM", "Cutscene", "LGBEventRange", "ContentFinderCondition", "Unknown15", "InstanceContentTextDataBossStart", "InstanceContentTextDataBossEnd", "BNpcBaseBoss", "InstanceContentTextDataObjectiveStart", "InstanceContentTextDataObjectiveEnd", "SortKey", "NewPlayerBonusGil", "NewPlayerBonusExp", "NewPlayerBonusA", "NewPlayerBonusB", "FinalBossExp", "Unknown8", "Unknown0", "FinalBossCurrencyA", "FinalBossCurrencyB", "FinalBossCurrencyC", "BossExp[0]", "BossExp[1]", "BossExp[2]", "BossExp[3]", "BossExp[4]", "BossCurrencyA[0]", "BossCurrencyA[1]", "BossCurrencyA[2]", "BossCurrencyA[3]", "BossCurrencyA[4]", "BossCurrencyB[0]", "BossCurrencyB[1]", "BossCurrencyB[2]", "BossCurrencyB[3]", "BossCurrencyB[4]", "BossCurrencyC[0]", "BossCurrencyC[1]", "BossCurrencyC[2]", "BossCurrencyC[3]", "BossCurrencyC[4]", "InstanceClearExp", "InstanceClearGil", "InstanceContentRewardItem", "Unknown1", "LimitedTimeBonus", "Unknown2", "InstanceContentBuff", "Unknown16", "ReqInstance", "PartyCondition", "Unknown9", "QTE1", "QTE2", "Unknown12", "ContentAttributeRect", "Unknown17", "ContentRoute", "ContentDirectorManagedSG", "ContentTodo", "Unknown13", "Unknown6", "LookupIndex", "Unknown18", "ContentEventItem", "ContentDirectorBattleTalk", "AllowPhoenixDown" };

pub fn newPlayerBonusGil(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn newPlayerBonusExp(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn finalBossExp(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub const boss_exp_len = 5;
pub fn bossExp(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub fn instanceClearExp(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn instanceClearGil(self: @This()) u32 {
    return self.row.at(u32, 40);
}

/// Links to `InstanceContentRewardItem`.
pub fn instanceContentRewardItem(self: @This()) excel.Link(sheets.InstanceContentRewardItem) {
    return .of(self.row.at(u32, 44));
}

pub fn newPlayerBonusA(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn newPlayerBonusB(self: @This()) u16 {
    return self.row.at(u16, 50);
}

pub fn finalBossCurrencyA(self: @This()) u16 {
    return self.row.at(u16, 52);
}

pub fn finalBossCurrencyB(self: @This()) u16 {
    return self.row.at(u16, 54);
}

pub fn finalBossCurrencyC(self: @This()) u16 {
    return self.row.at(u16, 56);
}

pub const boss_currency_a_len = 5;
pub fn bossCurrencyA(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

pub const boss_currency_b_len = 5;
pub fn bossCurrencyB(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_3[n0]);
}

pub const boss_currency_c_len = 5;
pub fn bossCurrencyC(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_4[n0]);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 88);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 90);
}

pub fn limitedTimeBonus(self: @This()) bool {
    return self.row.bitAt(91, 0);
}

/// Links to `Cutscene`.
pub fn cutscene(self: @This()) excel.Link(sheets.Cutscene) {
    return .of(self.row.at(u32, 92));
}

/// Points to the game object ID of the exit range.
pub fn lgbEventRange(self: @This()) u32 {
    return self.row.at(u32, 96);
}

/// Links to `InstanceContentTextData`.
pub fn instanceContentTextDataBossStart(self: @This()) excel.Link(sheets.InstanceContentTextData) {
    return .of(self.row.at(u32, 100));
}

/// Links to `InstanceContentTextData`.
pub fn instanceContentTextDataBossEnd(self: @This()) excel.Link(sheets.InstanceContentTextData) {
    return .of(self.row.at(u32, 104));
}

/// Links to `BNpcBase`.
pub fn bNpcBaseBoss(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u32, 108));
}

/// Links to `InstanceContentTextData`.
pub fn instanceContentTextDataObjectiveStart(self: @This()) excel.Link(sheets.InstanceContentTextData) {
    return .of(self.row.at(u32, 112));
}

/// Links to `InstanceContentTextData`.
pub fn instanceContentTextDataObjectiveEnd(self: @This()) excel.Link(sheets.InstanceContentTextData) {
    return .of(self.row.at(u32, 116));
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 120);
}

/// Links to `InstanceContent`.
pub fn reqInstance(self: @This()) excel.Link(sheets.InstanceContent) {
    return .of(self.row.at(u32, 124));
}

/// Links to `InstanceContentBuff`.
pub fn instanceContentBuff(self: @This()) excel.Link(sheets.InstanceContentBuff) {
    return .of(self.row.at(i32, 128));
}

pub fn timeLimitmin(self: @This()) u16 {
    return self.row.at(u16, 132);
}

/// Links to `BGM`.
pub fn bgm(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 134));
}

/// Links to `BGM`.
pub fn winBGM(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 136));
}

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u16, 138));
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 140);
}

/// Links by `InstanceContentType`: 8 to `Tutorial`, 16 to `IKDRoute`, 19 to `VVDData`, 20 to `VVDData`.
pub fn contentRoute(self: @This()) u16 {
    return self.row.at(u16, 142);
}

/// Links to `ContentDirectorManagedSG`.
pub fn contentDirectorManagedSG(self: @This()) excel.Link(sheets.ContentDirectorManagedSG) {
    return .of(self.row.at(u16, 144));
}

/// Links to `ContentTodo`.
pub fn contentTodo(self: @This()) excel.Link(sheets.ContentTodo) {
    return .of(self.row.at(u16, 146));
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 148);
}

/// Used for certain duties. If not 0, then the client reads from a special unlock/completed array in PlayerState.
pub fn lookupIndex(self: @This()) u16 {
    return self.row.at(u16, 150);
}

/// Links to `ContentEventItem`.
pub fn contentEventItem(self: @This()) excel.Link(sheets.ContentEventItem) {
    return .of(self.row.at(u16, 152));
}

/// Links to `ContentDirectorBattleTalk`.
pub fn contentDirectorBattleTalk(self: @This()) excel.Link(sheets.ContentDirectorBattleTalk) {
    return .of(self.row.at(u16, 154));
}

pub fn partyCondition(self: @This()) i16 {
    return self.row.at(i16, 156);
}

/// Links to `InstanceContentType`.
pub fn instanceContentType(self: @This()) excel.Link(sheets.InstanceContentType) {
    return .of(self.row.at(u8, 158));
}

pub fn weekRestriction(self: @This()) u8 {
    return self.row.at(u8, 159);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 160);
}

/// Links to `QTE`.
pub fn qte1(self: @This()) excel.Link(sheets.QTE) {
    return .of(self.row.at(u8, 161));
}

/// Links to `QTE`.
pub fn qte2(self: @This()) excel.Link(sheets.QTE) {
    return .of(self.row.at(u8, 162));
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 163);
}

/// Links to `ContentAttributeRect`.
pub fn contentAttributeRect(self: @This()) excel.Link(sheets.ContentAttributeRect) {
    return .of(self.row.at(u8, 164));
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 165);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(166, 0);
}

pub fn unknown15(self: @This()) bool {
    return self.row.bitAt(166, 1);
}

pub fn unknown16(self: @This()) bool {
    return self.row.bitAt(166, 2);
}

pub fn unknown17(self: @This()) bool {
    return self.row.bitAt(166, 3);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(166, 4);
}

pub fn allowPhoenixDown(self: @This()) bool {
    return self.row.bitAt(166, 5);
}

const offsets_1 = [5]u16{ 16, 20, 24, 28, 32 };
const offsets_2 = [5]u16{ 58, 60, 62, 64, 66 };
const offsets_3 = [5]u16{ 68, 70, 72, 74, 76 };
const offsets_4 = [5]u16{ 78, 80, 82, 84, 86 };
