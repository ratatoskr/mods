//! `HousingPreset`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingPreset = @This();

pub const sheet_name = "HousingPreset";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9184af18;
pub const Sheet = excel.Typed(HousingPreset);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Singular", "Adjective", "Plural", "PossessivePronoun", "StartsWithVowel", "Countability", "Pronoun", "Article", "PlaceName", "HousingSize", "ExteriorRoof", "ExteriorWall", "ExteriorWindow", "ExteriorDoor", "InteriorWall", "InteriorFlooring", "InteriorLighting", "OtherFloorWall", "OtherFloorFlooring", "OtherFloorLighting", "BasementWall", "BasementFlooring", "BasementLighting", "MansionLighting" };

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn adjective(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub fn possessivePronoun(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn startsWithVowel(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn countability(self: @This()) i8 {
    return self.row.at(i8, 11);
}

pub fn pronoun(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn article(self: @This()) i8 {
    return self.row.at(i8, 13);
}

/// Links to `Item`.
pub fn exteriorRoof(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 16));
}

/// Links to `Item`.
pub fn exteriorWall(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 20));
}

/// Links to `Item`.
pub fn exteriorWindow(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 24));
}

/// Links to `Item`.
pub fn exteriorDoor(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 28));
}

/// Links to `Item`.
pub fn interiorWall(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 32));
}

/// Links to `Item`.
pub fn interiorFlooring(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 36));
}

/// Links to `Item`.
pub fn interiorLighting(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 40));
}

/// Links to `Item`.
pub fn otherFloorWall(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 44));
}

/// Links to `Item`.
pub fn otherFloorFlooring(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 48));
}

/// Links to `Item`.
pub fn otherFloorLighting(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 52));
}

/// Links to `Item`.
pub fn basementWall(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 56));
}

/// Links to `Item`.
pub fn basementFlooring(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 60));
}

/// Links to `Item`.
pub fn basementLighting(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 64));
}

/// Links to `Item`.
pub fn mansionLighting(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 68));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 72));
}

pub fn housingSize(self: @This()) u8 {
    return self.row.at(u8, 74);
}
