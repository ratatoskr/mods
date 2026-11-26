//! `TerritoryType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TerritoryType = @This();

pub const sheet_name = "TerritoryType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfacf0e83;
pub const Sheet = excel.Typed(TerritoryType);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn bg(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `ArrayEventHandler`.
pub fn arrayEventHandler(self: @This()) excel.Link(sheets.ArrayEventHandler) {
    return .of(self.row.at(u32, 8));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn placeNameRegionIcon(self: @This()) i32 {
    return self.row.at(i32, 12);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn placeNameIcon(self: @This()) i32 {
    return self.row.at(i32, 16);
}

/// Links to `Aetheryte`.
pub fn aetheryte(self: @This()) excel.Link(sheets.Aetheryte) {
    return .of(self.row.at(i32, 20));
}

pub fn fixedTime(self: @This()) i32 {
    return self.row.at(i32, 24);
}

/// Links to `PlaceName`.
pub fn placeNameRegion(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 28));
}

/// Links to `PlaceName`.
pub fn placeNameZone(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 30));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 32));
}

/// Links to `Map`.
pub fn map(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u16, 34));
}

/// Links to `ContentFinderCondition`.
pub fn contentFinderCondition(self: @This()) excel.Link(sheets.ContentFinderCondition) {
    return .of(self.row.at(u16, 36));
}

/// Links to `BGM` or `BGMSituation`, whichever has the row.
pub fn bgm(self: @This()) u16 {
    return self.row.at(u16, 38);
}

/// Links to `QuestBattle`.
pub fn questBattle(self: @This()) excel.Link(sheets.QuestBattle) {
    return .of(self.row.at(u16, 40));
}

pub fn resident(self: @This()) u16 {
    return self.row.at(u16, 42);
}

/// Links to `NotoriousMonsterTerritory`.
pub fn notoriousMonsterTerritory(self: @This()) excel.Link(sheets.NotoriousMonsterTerritory) {
    return .of(self.row.at(u16, 44));
}

pub fn battalionMode(self: @This()) u8 {
    return self.row.at(u8, 46);
}

/// Links to `LoadingImage`.
pub fn loadingImage(self: @This()) excel.Link(sheets.LoadingImage) {
    return .of(self.row.at(u8, 47));
}

pub fn exclusiveType(self: @This()) u8 {
    return self.row.at(u8, 48);
}

/// Links to `TerritoryIntendedUse`.
pub fn territoryIntendedUse(self: @This()) excel.Link(sheets.TerritoryIntendedUse) {
    return .of(self.row.at(u8, 49));
}

/// Links to `WeatherRate`.
pub fn weatherRate(self: @This()) excel.Link(sheets.WeatherRate) {
    return .of(self.row.at(u8, 50));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 51);
}

/// Links to `ExVersion`.
pub fn exVersion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 52));
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 53);
}

/// Links to `ZoneSharedGroup`.
pub fn zoneSharedGroup(self: @This()) excel.Link(sheets.ZoneSharedGroup) {
    return .of(self.row.at(u8, 54));
}

/// Links to `AetherCurrentCompFlgSet`.
pub fn aetherCurrentCompFlgSet(self: @This()) excel.Link(sheets.AetherCurrentCompFlgSet) {
    return .of(self.row.at(u8, 55));
}

/// Links to `MountSpeed`.
pub fn mountSpeed(self: @This()) excel.Link(sheets.MountSpeed) {
    return .of(self.row.at(u8, 56));
}

/// Links to `IndividualWeather`.
pub fn individualWeather(self: @This()) excel.Link(sheets.IndividualWeather) {
    return .of(self.row.at(u8, 57));
}

pub fn achievementIndex(self: @This()) i8 {
    return self.row.at(i8, 58);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(59, 0);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(59, 1);
}

pub fn pcSearch(self: @This()) bool {
    return self.row.bitAt(59, 2);
}

pub fn stealth(self: @This()) bool {
    return self.row.bitAt(59, 3);
}

pub fn mount(self: @This()) bool {
    return self.row.bitAt(59, 4);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(59, 5);
}

pub fn isPvpZone(self: @This()) bool {
    return self.row.bitAt(59, 6);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(59, 7);
}

pub fn isInUse(self: @This()) bool {
    return self.row.bitAt(60, 0);
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(60, 1);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(60, 2);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(60, 3);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(60, 4);
}

pub fn unknown15(self: @This()) bool {
    return self.row.bitAt(60, 5);
}

pub fn unknown16(self: @This()) bool {
    return self.row.bitAt(60, 6);
}

pub fn unknown17(self: @This()) bool {
    return self.row.bitAt(60, 7);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(61, 0);
}
