//! `Aetheryte`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `PlaceName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Aetheryte = @This();

pub const sheet_name = "Aetheryte";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb41a2b3c;
pub const Sheet = excel.Typed(Aetheryte);

row: excel.Row,

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

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub const level_len = 4;
/// Links to `Level`.
pub fn level(self: @This(), n0: usize) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

/// Links to `Quest`.
pub fn requiredQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 36));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 40));
}

/// Links to `PlaceName`.
pub fn aethernetName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 42));
}

/// Links to `TerritoryType`.
pub fn territory(self: @This()) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, 44));
}

/// Links to `Map`.
pub fn map(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u16, 46));
}

pub fn aetherstreamX(self: @This()) i16 {
    return self.row.at(i16, 48);
}

pub fn aetherstreamY(self: @This()) i16 {
    return self.row.at(i16, 50);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 52);
}

pub fn aethernetGroup(self: @This()) u8 {
    return self.row.at(u8, 53);
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 54);
}

pub fn isAetheryte(self: @This()) bool {
    return self.row.bitAt(55, 0);
}

pub fn invisible(self: @This()) bool {
    return self.row.bitAt(55, 1);
}

const offsets_1 = [4]u16{ 20, 24, 28, 32 };
