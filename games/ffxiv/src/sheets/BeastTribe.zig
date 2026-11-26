//! `BeastTribe`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BeastTribe = @This();

pub const sheet_name = "BeastTribe";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc9fbf3f1;
pub const Sheet = excel.Typed(BeastTribe);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn nameRelation(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn adjective(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn possessivePronoun(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn startsWithVowel(self: @This()) i8 {
    return self.row.at(i8, 14);
}

pub fn pronoun(self: @This()) i8 {
    return self.row.at(i8, 15);
}

pub fn article(self: @This()) i8 {
    return self.row.at(i8, 16);
}

pub fn def(self: @This()) i8 {
    return self.row.at(i8, 17);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconReputation(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// Links to `Quest`.
pub fn intersocietalQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 28));
}

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 32));
}

/// Links to `Item`.
pub fn currencyItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 36));
}

pub fn minLevel(self: @This()) u8 {
    return self.row.at(u8, 40);
}

/// Links to `BeastRankBonus`.
pub fn beastRankBonus(self: @This()) excel.Link(sheets.BeastRankBonus) {
    return .of(self.row.at(u8, 41));
}

pub fn maxRank(self: @This()) u8 {
    return self.row.at(u8, 42);
}

/// Links to `ExVersion`.
pub fn expansion(self: @This()) excel.Link(sheets.ExVersion) {
    return .of(self.row.at(u8, 43));
}

pub fn displayOrder(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(45, 0);
}
