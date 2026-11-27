//! `Pet`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Pet = @This();

pub const sheet_name = "Pet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8758fc64;
pub const Sheet = excel.Typed(Pet);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Abilities[0]", "Abilities[1]", "Abilities[2]", "Abilities[3]", "AutoAction", "AutoDespawn", "NonCombatSummon", "ShowPetActionBar", "SmallScalePercentage", "MediumScalePercentage", "LargeScalePercentage", "Unknown14", "AllowedPetMirage[0]", "AllowedPetMirage[1]", "AllowedPetMirage[2]", "AllowedPetMirage[3]", "AllowedPetMirage[4]", "AllowedPetMirage[5]", "XBMPet" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const abilities_len = 4;
/// Links to `Action`.
pub fn abilities(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

/// Links to `Action`.
pub fn autoAction(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 12));
}

pub fn smallScalePercentage(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn mediumScalePercentage(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn largeScalePercentage(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub const allowed_pet_mirage_len = 6;
/// Links to `PetMirage`.
pub fn allowedPetMirage(self: @This(), n0: usize) excel.Link(sheets.PetMirage) {
    return .of(self.row.at(u8, offsets_2[n0]));
}

/// Links to `XBMPet`.
pub fn xbmPet(self: @This()) excel.Link(sheets.XBMPet) {
    return .of(self.row.at(u8, 23));
}

pub fn unknown14(self: @This()) i8 {
    return self.row.at(i8, 24);
}

pub fn autoDespawn(self: @This()) bool {
    return self.row.bitAt(25, 0);
}

pub fn nonCombatSummon(self: @This()) bool {
    return self.row.bitAt(25, 1);
}

pub fn showPetActionBar(self: @This()) bool {
    return self.row.bitAt(25, 2);
}

const offsets_1 = [4]u16{ 4, 6, 8, 10 };
const offsets_2 = [6]u16{ 17, 18, 19, 20, 21, 22 };
