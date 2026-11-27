//! `Attributive`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Attributive = @This();

pub const sheet_name = "Attributive";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xecf11b18;
pub const Sheet = excel.Typed(Attributive);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "JapaneseDemonstrative", "JapaneseDemonstrativePlural", "EnglishConsonantSingular", "EnglishConsonantGeneric", "EnglishConsonantPlural", "EnglishVowelSingular", "EnglishVowelGeneric", "EnglishVowelPlural", "GermanNominativeMasculine", "GermanNominativeFeminine", "GermanNominativeNeutral", "GermanNominativePlural", "GermanGenitiveMasculine", "GermanGenitiveFeminine", "GermanGenitiveNeutral", "GermanGenitivePlural", "GermanDativeMasculine", "GermanDativeFeminine", "GermanDativeNeutral", "GermanDativePlural", "GermanAccusativeMasculine", "GermanAccusativeFeminine", "GermanAccusativeNeutral", "GermanAccusativePlural", "FrenchMasculineConsonantBase", "FrenchMasculineConsonantSingular", "FrenchMasculineConsonantPlural", "FrenchMasculineConsonantMass", "FrenchMasculineVowelBase", "FrenchMasculineVowelSingular", "FrenchMasculineVowelPlural", "FrenchMasculineVowelMass", "FrenchFeminineConsonantBase", "FrenchFeminineConsonantSingular", "FrenchFeminineConsonantPlural", "FrenchFeminineConsonantMass", "FrenchFeminineVowelBase", "FrenchFeminineVowelSingular", "FrenchFeminineVowelPlural", "FrenchFeminineVowelMass", "Unknown40" };

pub fn japaneseDemonstrative(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn japaneseDemonstrativePlural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn englishConsonantSingular(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn englishConsonantGeneric(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn englishConsonantPlural(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn englishVowelSingular(self: @This()) []const u8 {
    return self.row.stringAt(20);
}

pub fn englishVowelGeneric(self: @This()) []const u8 {
    return self.row.stringAt(24);
}

pub fn englishVowelPlural(self: @This()) []const u8 {
    return self.row.stringAt(28);
}

pub fn germanNominativeMasculine(self: @This()) []const u8 {
    return self.row.stringAt(32);
}

pub fn germanNominativeFeminine(self: @This()) []const u8 {
    return self.row.stringAt(36);
}

pub fn germanNominativeNeutral(self: @This()) []const u8 {
    return self.row.stringAt(40);
}

pub fn germanNominativePlural(self: @This()) []const u8 {
    return self.row.stringAt(44);
}

pub fn germanGenitiveMasculine(self: @This()) []const u8 {
    return self.row.stringAt(48);
}

pub fn germanGenitiveFeminine(self: @This()) []const u8 {
    return self.row.stringAt(52);
}

pub fn germanGenitiveNeutral(self: @This()) []const u8 {
    return self.row.stringAt(56);
}

pub fn germanGenitivePlural(self: @This()) []const u8 {
    return self.row.stringAt(60);
}

pub fn germanDativeMasculine(self: @This()) []const u8 {
    return self.row.stringAt(64);
}

pub fn germanDativeFeminine(self: @This()) []const u8 {
    return self.row.stringAt(68);
}

pub fn germanDativeNeutral(self: @This()) []const u8 {
    return self.row.stringAt(72);
}

pub fn germanDativePlural(self: @This()) []const u8 {
    return self.row.stringAt(76);
}

pub fn germanAccusativeMasculine(self: @This()) []const u8 {
    return self.row.stringAt(80);
}

pub fn germanAccusativeFeminine(self: @This()) []const u8 {
    return self.row.stringAt(84);
}

pub fn germanAccusativeNeutral(self: @This()) []const u8 {
    return self.row.stringAt(88);
}

pub fn germanAccusativePlural(self: @This()) []const u8 {
    return self.row.stringAt(92);
}

pub fn frenchMasculineConsonantBase(self: @This()) []const u8 {
    return self.row.stringAt(96);
}

pub fn frenchMasculineConsonantSingular(self: @This()) []const u8 {
    return self.row.stringAt(100);
}

pub fn frenchMasculineConsonantPlural(self: @This()) []const u8 {
    return self.row.stringAt(104);
}

pub fn frenchMasculineConsonantMass(self: @This()) []const u8 {
    return self.row.stringAt(108);
}

pub fn frenchMasculineVowelBase(self: @This()) []const u8 {
    return self.row.stringAt(112);
}

pub fn frenchMasculineVowelSingular(self: @This()) []const u8 {
    return self.row.stringAt(116);
}

pub fn frenchMasculineVowelPlural(self: @This()) []const u8 {
    return self.row.stringAt(120);
}

pub fn frenchMasculineVowelMass(self: @This()) []const u8 {
    return self.row.stringAt(124);
}

pub fn frenchFeminineConsonantBase(self: @This()) []const u8 {
    return self.row.stringAt(128);
}

pub fn frenchFeminineConsonantSingular(self: @This()) []const u8 {
    return self.row.stringAt(132);
}

pub fn frenchFeminineConsonantPlural(self: @This()) []const u8 {
    return self.row.stringAt(136);
}

pub fn frenchFeminineConsonantMass(self: @This()) []const u8 {
    return self.row.stringAt(140);
}

pub fn frenchFeminineVowelBase(self: @This()) []const u8 {
    return self.row.stringAt(144);
}

pub fn frenchFeminineVowelSingular(self: @This()) []const u8 {
    return self.row.stringAt(148);
}

pub fn frenchFeminineVowelPlural(self: @This()) []const u8 {
    return self.row.stringAt(152);
}

pub fn frenchFeminineVowelMass(self: @This()) []const u8 {
    return self.row.stringAt(156);
}

pub fn unknown40(self: @This()) []const u8 {
    return self.row.stringAt(160);
}
