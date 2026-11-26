//! `ENpcBase`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ENpcBase = @This();

pub const sheet_name = "ENpcBase";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5ba9e1a6;
pub const Sheet = excel.Typed(ENpcBase);

row: excel.Row,

pub const e_npc_data_len = 32;
/// Links to `ChocoboTaxiStand`, `CollectablesShop`, `ContentNpc`, `CraftLeve`, `CustomTalk`, `DefaultTalk`, `DisposalShop`, `DpsChallengeOfficer`, `EventPathMove`, `FccShop`, `GCShop`, `GilShop`, `GuildOrderGuide`, `GuildOrderOfficer`, `GuildleveAssignment`, `InclusionShop`, `LotteryExchangeShop`, `PreHandler`, `Quest`, `SpecialShop`, `Story`, `SwitchTalk`, `TopicSelect`, `TripleTriad` or `Warp`, whichever has the row.
pub fn eNpcData(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub fn modelMainHand(self: @This()) u64 {
    return self.row.at(u64, 128);
}

pub fn modelOffHand(self: @This()) u64 {
    return self.row.at(u64, 136);
}

pub fn scale(self: @This()) f32 {
    return self.row.at(f32, 144);
}

pub fn modelHead(self: @This()) u32 {
    return self.row.at(u32, 148);
}

pub fn modelBody(self: @This()) u32 {
    return self.row.at(u32, 152);
}

pub fn modelHands(self: @This()) u32 {
    return self.row.at(u32, 156);
}

pub fn modelLegs(self: @This()) u32 {
    return self.row.at(u32, 160);
}

pub fn modelFeet(self: @This()) u32 {
    return self.row.at(u32, 164);
}

pub fn modelEars(self: @This()) u32 {
    return self.row.at(u32, 168);
}

pub fn modelNeck(self: @This()) u32 {
    return self.row.at(u32, 172);
}

pub fn modelWrists(self: @This()) u32 {
    return self.row.at(u32, 176);
}

pub fn modelLeftRing(self: @This()) u32 {
    return self.row.at(u32, 180);
}

pub fn modelRightRing(self: @This()) u32 {
    return self.row.at(u32, 184);
}

pub fn eventHandler(self: @This()) u16 {
    return self.row.at(u16, 188);
}

/// Links to `ModelChara`.
pub fn modelChara(self: @This()) excel.Link(sheets.ModelChara) {
    return .of(self.row.at(u16, 190));
}

/// Links to `NpcEquip`.
pub fn npcEquip(self: @This()) excel.Link(sheets.NpcEquip) {
    return .of(self.row.at(u16, 192));
}

/// Links to `Behavior`.
pub fn behavior(self: @This()) excel.Link(sheets.Behavior) {
    return .of(self.row.at(u16, 194));
}

pub fn unknown_70_1(self: @This()) u16 {
    return self.row.at(u16, 196);
}

pub fn unknown_70_2(self: @This()) u16 {
    return self.row.at(u16, 198);
}

/// Links to `Balloon`.
pub fn balloon(self: @This()) excel.Link(sheets.Balloon) {
    return .of(self.row.at(u16, 200));
}

/// Links to `Race`.
pub fn race(self: @This()) excel.Link(sheets.Race) {
    return .of(self.row.at(u8, 202));
}

pub fn gender(self: @This()) u8 {
    return self.row.at(u8, 203);
}

pub fn bodyType(self: @This()) u8 {
    return self.row.at(u8, 204);
}

pub fn height(self: @This()) u8 {
    return self.row.at(u8, 205);
}

/// Links to `Tribe`.
pub fn tribe(self: @This()) excel.Link(sheets.Tribe) {
    return .of(self.row.at(u8, 206));
}

pub fn face(self: @This()) u8 {
    return self.row.at(u8, 207);
}

pub fn hairStyle(self: @This()) u8 {
    return self.row.at(u8, 208);
}

pub fn hairHighlight(self: @This()) u8 {
    return self.row.at(u8, 209);
}

pub fn skinColor(self: @This()) u8 {
    return self.row.at(u8, 210);
}

pub fn eyeHeterochromia(self: @This()) u8 {
    return self.row.at(u8, 211);
}

pub fn hairColor(self: @This()) u8 {
    return self.row.at(u8, 212);
}

pub fn hairHighlightColor(self: @This()) u8 {
    return self.row.at(u8, 213);
}

pub fn facialFeature(self: @This()) u8 {
    return self.row.at(u8, 214);
}

pub fn facialFeatureColor(self: @This()) u8 {
    return self.row.at(u8, 215);
}

pub fn eyebrows(self: @This()) u8 {
    return self.row.at(u8, 216);
}

pub fn eyeColor(self: @This()) u8 {
    return self.row.at(u8, 217);
}

pub fn eyeShape(self: @This()) u8 {
    return self.row.at(u8, 218);
}

pub fn nose(self: @This()) u8 {
    return self.row.at(u8, 219);
}

pub fn jaw(self: @This()) u8 {
    return self.row.at(u8, 220);
}

pub fn mouth(self: @This()) u8 {
    return self.row.at(u8, 221);
}

pub fn lipColor(self: @This()) u8 {
    return self.row.at(u8, 222);
}

pub fn bustOrTone1(self: @This()) u8 {
    return self.row.at(u8, 223);
}

pub fn extraFeature1(self: @This()) u8 {
    return self.row.at(u8, 224);
}

pub fn extraFeature2OrBust(self: @This()) u8 {
    return self.row.at(u8, 225);
}

pub fn facePaint(self: @This()) u8 {
    return self.row.at(u8, 226);
}

pub fn facePaintColor(self: @This()) u8 {
    return self.row.at(u8, 227);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 228);
}

/// Links to `Stain`.
pub fn dyeMainHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 229));
}

/// Links to `Stain`.
pub fn dye2MainHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 230));
}

/// Links to `Stain`.
pub fn dyeOffHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 231));
}

/// Links to `Stain`.
pub fn dye2OffHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 232));
}

/// Links to `Stain`.
pub fn dyeHead(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 233));
}

/// Links to `Stain`.
pub fn dyeBody(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 234));
}

/// Links to `Stain`.
pub fn dyeHands(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 235));
}

/// Links to `Stain`.
pub fn dyeLegs(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 236));
}

/// Links to `Stain`.
pub fn dyeFeet(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 237));
}

/// Links to `Stain`.
pub fn dyeEars(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 238));
}

/// Links to `Stain`.
pub fn dyeNeck(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 239));
}

/// Links to `Stain`.
pub fn dyeWrists(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 240));
}

/// Links to `Stain`.
pub fn dyeLeftRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 241));
}

/// Links to `Stain`.
pub fn dyeRightRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 242));
}

/// Links to `Stain`.
pub fn dye2Head(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 243));
}

/// Links to `Stain`.
pub fn dye2Body(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 244));
}

/// Links to `Stain`.
pub fn dye2Hands(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 245));
}

/// Links to `Stain`.
pub fn dye2Legs(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 246));
}

/// Links to `Stain`.
pub fn dye2Feet(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 247));
}

/// Links to `Stain`.
pub fn dye2Ears(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 248));
}

/// Links to `Stain`.
pub fn dye2Neck(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 249));
}

/// Links to `Stain`.
pub fn dye2Wrists(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 250));
}

/// Links to `Stain`.
pub fn dye2LeftRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 251));
}

/// Links to `Stain`.
pub fn dye2RightRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 252));
}

pub fn invisibility(self: @This()) u8 {
    return self.row.at(u8, 253);
}

pub fn defaultBalloon(self: @This()) u8 {
    return self.row.at(u8, 254);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 255);
}

pub fn important(self: @This()) bool {
    return self.row.bitAt(256, 0);
}

pub fn visor(self: @This()) bool {
    return self.row.bitAt(256, 1);
}

pub fn notRewriteHeight(self: @This()) bool {
    return self.row.bitAt(256, 2);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(256, 3);
}

const offsets_1 = [32]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124 };
