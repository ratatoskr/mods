//! `GCRankLimsaMaleText`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GCRankLimsaMaleText = @This();

pub const sheet_name = "GCRankLimsaMaleText";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd573cba6;
pub const Sheet = excel.Typed(GCRankLimsaMaleText);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Singular", "Adjective", "Plural", "PossessivePronoun", "StartsWithVowel", "Countability", "Pronoun", "Article", "NameRank", "Unknown0" };

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn nameRank(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown0(self: @This()) []const u8 {
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
