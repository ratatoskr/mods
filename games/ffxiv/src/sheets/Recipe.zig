//! `Recipe`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ItemResult`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Recipe = @This();

pub const sheet_name = "Recipe";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbeae287b;
pub const Sheet = excel.Typed(Recipe);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Number", "CraftType", "RecipeLevelTable", "MaxAdjustableJobLevel", "ItemResult", "AmountResult", "Ingredient[0]", "AmountIngredient[0]", "Ingredient[1]", "AmountIngredient[1]", "Ingredient[2]", "AmountIngredient[2]", "Ingredient[3]", "AmountIngredient[3]", "Ingredient[4]", "AmountIngredient[4]", "Ingredient[5]", "AmountIngredient[5]", "Ingredient[6]", "AmountIngredient[6]", "Ingredient[7]", "AmountIngredient[7]", "RecipeNotebookList", "DisplayPriority", "IsSecondary", "MaterialQualityFactor", "DifficultyFactor", "QualityFactor", "DurabilityFactor", "RequiredQuality", "RequiredCraftsmanship", "RequiredControl", "QuickSynthCraftsmanship", "QuickSynthControl", "SecretRecipeBook", "Quest", "CanQuickSynth", "CanHq", "ExpRewarded", "Unknown1", "StatusRequired", "ItemRequired", "IsSpecializationRequired", "IsExpert", "CollectableMetadataKey", "CollectableMetadata", "PatchNumber" };

pub fn requiredQuality(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

pub fn number(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `CraftType`.
pub fn craftType(self: @This()) excel.Link(sheets.CraftType) {
    return .of(self.row.at(i32, 12));
}

/// Links to `Item`.
pub fn itemResult(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 16));
}

pub const ingredient_len = 8;
/// Links to `Item`.
pub fn ingredient(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

/// Links to `Status`.
pub fn statusRequired(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(i32, 52));
}

/// Links to `Item`.
pub fn itemRequired(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 56));
}

/// Links to `RecipeLevelTable`.
pub fn recipeLevelTable(self: @This()) excel.Link(sheets.RecipeLevelTable) {
    return .of(self.row.at(u16, 60));
}

/// Links to `GathererCrafterLvAdjustTable`.
pub fn maxAdjustableJobLevel(self: @This()) excel.Link(sheets.GathererCrafterLvAdjustTable) {
    return .of(self.row.at(u16, 62));
}

/// Links to `RecipeNotebookList`.
pub fn recipeNotebookList(self: @This()) excel.Link(sheets.RecipeNotebookList) {
    return .of(self.row.at(u16, 64));
}

pub fn displayPriority(self: @This()) u16 {
    return self.row.at(u16, 66);
}

pub fn difficultyFactor(self: @This()) u16 {
    return self.row.at(u16, 68);
}

pub fn qualityFactor(self: @This()) u16 {
    return self.row.at(u16, 70);
}

pub fn durabilityFactor(self: @This()) u16 {
    return self.row.at(u16, 72);
}

pub fn requiredCraftsmanship(self: @This()) u16 {
    return self.row.at(u16, 74);
}

pub fn requiredControl(self: @This()) u16 {
    return self.row.at(u16, 76);
}

pub fn quickSynthCraftsmanship(self: @This()) u16 {
    return self.row.at(u16, 78);
}

pub fn quickSynthControl(self: @This()) u16 {
    return self.row.at(u16, 80);
}

/// Links to `SecretRecipeBook`.
pub fn secretRecipeBook(self: @This()) excel.Link(sheets.SecretRecipeBook) {
    return .of(self.row.at(u16, 82));
}

/// Links by `CollectableMetadataKey`: 1 to `CollectablesShopRefine`, 2 to `HWDCrafterSupply`, 3 to `SatisfactionSupply`, 4 to `SharlayanCraftWorksSupply`, 6 to `CollectablesRefine`, 7 to `WKSMissionToDoEvalutionRefin`.
pub fn collectableMetadata(self: @This()) u16 {
    return self.row.at(u16, 84);
}

pub fn patchNumber(self: @This()) u16 {
    return self.row.at(u16, 86);
}

pub fn amountResult(self: @This()) u8 {
    return self.row.at(u8, 88);
}

pub const amount_ingredient_len = 8;
pub fn amountIngredient(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub fn materialQualityFactor(self: @This()) u8 {
    return self.row.at(u8, 97);
}

pub fn collectableMetadataKey(self: @This()) u8 {
    return self.row.at(u8, 98);
}

pub fn isSecondary(self: @This()) bool {
    return self.row.bitAt(99, 0);
}

pub fn canQuickSynth(self: @This()) bool {
    return self.row.bitAt(99, 1);
}

pub fn canHq(self: @This()) bool {
    return self.row.bitAt(99, 2);
}

pub fn expRewarded(self: @This()) bool {
    return self.row.bitAt(99, 3);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(99, 4);
}

pub fn isSpecializationRequired(self: @This()) bool {
    return self.row.bitAt(99, 5);
}

pub fn isExpert(self: @This()) bool {
    return self.row.bitAt(99, 6);
}

const offsets_1 = [8]u16{ 20, 24, 28, 32, 36, 40, 44, 48 };
const offsets_2 = [8]u16{ 89, 90, 91, 92, 93, 94, 95, 96 };
