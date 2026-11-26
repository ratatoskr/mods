//! `Item`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Item = @This();

pub const sheet_name = "Item";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe9a33c9d;
pub const Sheet = excel.Typed(Item);

row: excel.Row,

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn adjective(self: @This()) i8 {
    return self.row.at(i8, 16);
}

pub fn possessivePronoun(self: @This()) i8 {
    return self.row.at(i8, 17);
}

pub fn startsWithVowel(self: @This()) i8 {
    return self.row.at(i8, 18);
}

pub fn countability(self: @This()) i8 {
    return self.row.at(i8, 19);
}

pub fn pronoun(self: @This()) i8 {
    return self.row.at(i8, 20);
}

pub fn article(self: @This()) i8 {
    return self.row.at(i8, 21);
}

/// A model id, packed.
pub fn modelMain(self: @This()) u64 {
    return self.row.at(u64, 24);
}

/// A model id, packed.
pub fn modelSub(self: @This()) u64 {
    return self.row.at(u64, 32);
}

pub fn damagePhys(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn damageMag(self: @This()) u16 {
    return self.row.at(u16, 42);
}

pub fn delayms(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn blockRate(self: @This()) u16 {
    return self.row.at(u16, 46);
}

pub fn block(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn defensePhys(self: @This()) u16 {
    return self.row.at(u16, 50);
}

pub fn defenseMag(self: @This()) u16 {
    return self.row.at(u16, 52);
}

pub const base_param_value_len = 6;
pub fn baseParamValue(self: @This(), n0: usize) i16 {
    return self.row.at(i16, offsets_1[n0]);
}

pub const base_param_value_special_len = 6;
pub fn baseParamValueSpecial(self: @This(), n0: usize) i16 {
    return self.row.at(i16, offsets_2[n0]);
}

pub fn levelEquip(self: @This()) u8 {
    return self.row.at(u8, 78);
}

pub fn requiredPvpRank(self: @This()) u8 {
    return self.row.at(u8, 79);
}

/// Links to `EquipRaceCategory`.
pub fn equipRestriction(self: @This()) excel.Link(sheets.EquipRaceCategory) {
    return .of(self.row.at(u8, 80));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 81));
}

/// Links to `GrandCompany`.
pub fn grandCompany(self: @This()) excel.Link(sheets.GrandCompany) {
    return .of(self.row.at(u8, 82));
}

/// Links to `ItemSeries`.
pub fn itemSeries(self: @This()) excel.Link(sheets.ItemSeries) {
    return .of(self.row.at(u8, 83));
}

pub fn baseParamModifier(self: @This()) u8 {
    return self.row.at(u8, 84);
}

/// Links to `ClassJob`.
pub fn classJobUse(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 85));
}

/// 1 = slashing (GLA/PLD, MRD/WAR, ROG/NIN, DRK, SAM, GNB, RPR, VPR, AST; CRP saw, LTW knife, BTN hatchet)
/// 2 = piercing (LNC/DRG, ARC/BRD, MCH, DNC, RDM; WVR needle)
/// 3 = blunt (PGL/MNK, CNJ/WHM, THM/BLM, ACN/SMN, SCH, SGE, BLU, PCT; BSM/ARM/GSM hammers, ALC, CUL, MIN pick, FSH rod)
pub fn damagePhysType(self: @This()) u8 {
    return self.row.at(u8, 86);
}

pub fn defaultActionRange(self: @This()) u8 {
    return self.row.at(u8, 87);
}

pub const base_param_len = 6;
/// Links to `BaseParam`.
pub fn baseParam(self: @This(), n0: usize) excel.Link(sheets.BaseParam) {
    return .of(self.row.at(u8, offsets_3[n0]));
}

/// Links to `ItemSpecialBonus`.
pub fn itemSpecialBonus(self: @This()) excel.Link(sheets.ItemSpecialBonus) {
    return .of(self.row.at(u8, 94));
}

pub fn itemSpecialBonusParam(self: @This()) u8 {
    return self.row.at(u8, 95);
}

pub const base_param_special_len = 6;
/// Links to `BaseParam`.
pub fn baseParamSpecial(self: @This(), n0: usize) excel.Link(sheets.BaseParam) {
    return .of(self.row.at(u8, offsets_4[n0]));
}

pub fn materializeType(self: @This()) u8 {
    return self.row.at(u8, 102);
}

pub fn materiaSlotCount(self: @This()) u8 {
    return self.row.at(u8, 103);
}

pub fn subStatCategory(self: @This()) u8 {
    return self.row.at(u8, 104);
}

pub fn isAdvancedMeldingPermitted(self: @This()) bool {
    return self.row.bitAt(105, 0);
}

pub fn isPvP(self: @This()) bool {
    return self.row.bitAt(105, 1);
}

pub fn isGlamorous(self: @This()) bool {
    return self.row.bitAt(105, 2);
}

/// Links by `FilterGroup`: 14 to `HousingExterior`, `HousingInterior`, `HousingYardObject`, `HousingFurniture`, `HousingPreset` or `HousingUnitedExterior`, 15 to `Stain`, 18 to `TreasureHuntRank`, 20 to `GardeningSeed`, 25 to `AetherialWheel`, 26 to `CompanyAction`, 27 to `TripleTriadCard`, 28 to `AirshipExplorationPart`, 32 to `Orchestrion`, 36 to `SubmarinePart`.
pub fn additionalData(self: @This()) u32 {
    return self.row.at(u32, 112);
}

pub fn stackSize(self: @This()) u32 {
    return self.row.at(u32, 116);
}

pub fn priceMid(self: @This()) u32 {
    return self.row.at(u32, 120);
}

pub fn priceLow(self: @This()) u32 {
    return self.row.at(u32, 124);
}

/// Links to `ItemRepairResource`.
pub fn itemRepair(self: @This()) excel.Link(sheets.ItemRepairResource) {
    return .of(self.row.at(i32, 128));
}

/// Links to `Item`.
pub fn itemGlamour(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 132));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 136);
}

/// Links to `ItemLevel`.
pub fn levelItem(self: @This()) excel.Link(sheets.ItemLevel) {
    return .of(self.row.at(u16, 138));
}

/// Used in conjunction with the ItemUICategory sortkeys to sort things like vendor lists
pub fn subcategorySort(self: @This()) u16 {
    return self.row.at(u16, 140);
}

/// Links to `ItemAction`.
pub fn itemAction(self: @This()) excel.Link(sheets.ItemAction) {
    return .of(self.row.at(u16, 142));
}

pub fn cooldowns(self: @This()) u16 {
    return self.row.at(u16, 144);
}

pub fn desynth(self: @This()) u16 {
    return self.row.at(u16, 146);
}

pub fn aetherialReduce(self: @This()) u16 {
    return self.row.at(u16, 148);
}

pub fn rarity(self: @This()) u8 {
    return self.row.at(u8, 150);
}

/// 1 = Physical Weapon
/// 2 = Magical Weapon
/// 3 = Shield
/// 4 = Gear
/// 5 = Meal
/// 6 = Medicine
/// 7 = Deep Dungeon Usable (Manuals, Medicine, Potions)
/// 8 = Potion (HP)
/// 9 = Ether (MP)
/// 10 = Elixir (HP+MP)
/// 11 = Crystal
/// 12 = Crafting Material
/// 13 = Materia
/// 14 = Housing
/// 15 = Dyes
/// 16 = Misc (Various stuff)
/// 17 = Fishing Bait
/// 18 = Treasure Map
/// 19 = Useables (Various stuff)
/// 20 = Gardening Seed
/// 21 = Gardening Soil
/// 22 = Gardening Fertilizer
/// 23 = Secret Recipe Book
/// 24 = unused
/// 25 = Aetherial Wheel
/// 26 = Primed Aetherial Wheel
/// 27 = Triple Triad Card
/// 28 = Airship Component
/// 29 = Currency
/// 30 = Folklore Book
/// 31 = Soul Crystal
/// 32 = Orchestrion Roll
/// 33 = Aquarium Tank Trimming
/// 34 = Painting
/// 35 = Tales Of Adventure Retainer
/// 36 = Submersible Component
/// 37 = Eureka Logos Action Ingredient
/// 38 = Bozja Mettle
/// 39 = Bozja Lost Action
/// 40 = Bozjan Cluster
/// 41 = unused
/// 42 = unused
/// 43 = Placeholder Item
/// 44 = Belts
/// 45 = ArchiveItem (RowId in AdditionalData)
/// 46 = unused
/// 47 = Sanctuary Cowrie
/// 48 = Sanctuary Material
/// 49 = Adventurers Parcel
/// 50 = Cosmic Exploration Material
/// 51 = Outfit
/// 52 = Occult Crescent Knowledge
/// 53 = Occult Crescent Phantom Experience
/// 54 = Occult Crescent Enlightenment Piece
/// 55 = Cosmic Exploration Cosmocredit
/// 56 = Cosmic Exploration Lunar Credit
/// 57 = Occult Crescent Sanguine Cipher
/// 58 = Cosmic Exploration Dronebits
/// 59 = Cosmic Exploration Tool Mastery Points
/// 60 = Old Dyes
pub fn filterGroup(self: @This()) u8 {
    return self.row.at(u8, 151);
}

/// Links to `ItemUICategory`.
pub fn itemUICategory(self: @This()) excel.Link(sheets.ItemUICategory) {
    return .of(self.row.at(u8, 152));
}

/// Links to `ItemSearchCategory`.
pub fn itemSearchCategory(self: @This()) excel.Link(sheets.ItemSearchCategory) {
    return .of(self.row.at(u8, 153));
}

/// Links to `EquipSlotCategory`.
pub fn equipSlotCategory(self: @This()) excel.Link(sheets.EquipSlotCategory) {
    return .of(self.row.at(u8, 154));
}

/// Links to `ItemSortCategory`.
pub fn itemSortCategory(self: @This()) excel.Link(sheets.ItemSortCategory) {
    return .of(self.row.at(u8, 155));
}

pub fn dyeCount(self: @This()) u8 {
    return self.row.at(u8, 156);
}

pub fn castTimeSeconds(self: @This()) u8 {
    return self.row.at(u8, 157);
}

/// This applies to both repairs and desynthesis, so irreparable but desynthesizable items such as fish or furniture will have a ClassJobRepair value.
/// Links to `ClassJob`.
pub fn classJobRepair(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 158));
}

pub fn isUnique(self: @This()) bool {
    return self.row.bitAt(159, 0);
}

pub fn isUntradable(self: @This()) bool {
    return self.row.bitAt(159, 1);
}

pub fn isIndisposable(self: @This()) bool {
    return self.row.bitAt(159, 2);
}

pub fn lot(self: @This()) bool {
    return self.row.bitAt(159, 3);
}

pub fn canBeHq(self: @This()) bool {
    return self.row.bitAt(159, 4);
}

pub fn isCrestWorthy(self: @This()) bool {
    return self.row.bitAt(159, 5);
}

pub fn isCollectable(self: @This()) bool {
    return self.row.bitAt(159, 6);
}

pub fn alwaysCollectable(self: @This()) bool {
    return self.row.bitAt(159, 7);
}

const offsets_1 = [6]u16{ 54, 56, 58, 60, 62, 64 };
const offsets_2 = [6]u16{ 66, 68, 70, 72, 74, 76 };
const offsets_3 = [6]u16{ 88, 89, 90, 91, 92, 93 };
const offsets_4 = [6]u16{ 96, 97, 98, 99, 100, 101 };
