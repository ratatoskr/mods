//! `GrandCompany`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GrandCompany = @This();

pub const sheet_name = "GrandCompany";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x472d6d8c;
pub const Sheet = excel.Typed(GrandCompany);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Singular", "Adjective", "Plural", "PossessivePronoun", "StartsWithVowel", "Countability", "Pronoun", "Article", "NamePrepositional", "MonsterNote" };

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn namePrepositional(self: @This()) []const u8 {
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

pub fn countability(self: @This()) i8 {
    return self.row.at(i8, 15);
}

pub fn pronoun(self: @This()) i8 {
    return self.row.at(i8, 16);
}

pub fn article(self: @This()) i8 {
    return self.row.at(i8, 17);
}

/// Links to `MonsterNote`.
pub fn monsterNote(self: @This()) excel.Link(sheets.MonsterNote) {
    return .of(self.row.at(i8, 20));
}
