//! `Leve`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Leve = @This();

pub const sheet_name = "Leve";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdab38bf5;
pub const Sheet = excel.Typed(Leve);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Description", "LeveClient", "Unknown1", "LeveAssignmentType", "Town", "ClassJobLevel", "TimeLimit", "AllowanceCost", "PlaceNameStart", "PlaceNameIssued", "FishingSpot", "SpearfishingNotebook", "ClassJobCategory", "JournalGenre", "PlaceNameStartZone", "IconCityState", "DataId", "CanCancel", "MaxDifficulty", "ExpFactor", "ExpReward", "GilReward", "LeveRewardItem", "LeveVfx", "LeveVfxFrame", "LevelLevemete", "IconIssuer", "LockedLeve", "LevelStart", "BGM" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn expFactor(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn expReward(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn gilReward(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// Links to `LeveRewardItem`.
pub fn leveRewardItem(self: @This()) excel.Link(sheets.LeveRewardItem) {
    return .of(self.row.at(u16, 20));
}

/// Links to `JournalGenre`.
pub fn journalGenre(self: @This()) excel.Link(sheets.JournalGenre) {
    return .of(self.row.at(u32, 24));
}

/// Links to `Level`.
pub fn levelLevemete(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 28));
}

/// Links to `Level`.
pub fn levelStart(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 32));
}

/// Links to `LeveClient`.
pub fn leveClient(self: @This()) excel.Link(sheets.LeveClient) {
    return .of(self.row.at(i32, 36));
}

/// Links to `LeveAssignmentType`.
pub fn leveAssignmentType(self: @This()) excel.Link(sheets.LeveAssignmentType) {
    return .of(self.row.at(i32, 40));
}

/// Links to `Town`.
pub fn town(self: @This()) excel.Link(sheets.Town) {
    return .of(self.row.at(i32, 44));
}

/// Links to `PlaceName`.
pub fn placeNameStart(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(i32, 48));
}

/// Links to `PlaceName`.
pub fn placeNameIssued(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(i32, 52));
}

/// Links to `PlaceName`.
pub fn placeNameStartZone(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(i32, 56));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconCityState(self: @This()) i32 {
    return self.row.at(i32, 60);
}

/// Links to `CraftLeve`, `CompanyLeve`, `GatheringLeve` or `BattleLeve`, whichever has the row.
pub fn dataId(self: @This()) i32 {
    return self.row.at(i32, 64);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconIssuer(self: @This()) i32 {
    return self.row.at(i32, 68);
}

pub fn classJobLevel(self: @This()) u16 {
    return self.row.at(u16, 72);
}

/// Links to `FishingSpot`.
pub fn fishingSpot(self: @This()) excel.Link(sheets.FishingSpot) {
    return .of(self.row.at(u16, 74));
}

/// Links to `BGM`.
pub fn bgm(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(u16, 76));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 78);
}

pub fn timeLimit(self: @This()) u8 {
    return self.row.at(u8, 79);
}

pub fn allowanceCost(self: @This()) u8 {
    return self.row.at(u8, 80);
}

/// Links to `SpearfishingNotebook`.
pub fn spearfishingNotebook(self: @This()) excel.Link(sheets.SpearfishingNotebook) {
    return .of(self.row.at(u8, 81));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 82));
}

pub fn maxDifficulty(self: @This()) u8 {
    return self.row.at(u8, 83);
}

/// Links to `LeveVfx`.
pub fn leveVfx(self: @This()) excel.Link(sheets.LeveVfx) {
    return .of(self.row.at(u8, 84));
}

/// Links to `LeveVfx`.
pub fn leveVfxFrame(self: @This()) excel.Link(sheets.LeveVfx) {
    return .of(self.row.at(u8, 85));
}

pub fn canCancel(self: @This()) bool {
    return self.row.bitAt(86, 0);
}

pub fn lockedLeve(self: @This()) bool {
    return self.row.bitAt(86, 1);
}
