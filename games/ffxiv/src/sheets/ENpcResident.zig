//! `ENpcResident`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ENpcResident = @This();

pub const sheet_name = "ENpcResident";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf74fa88c;
pub const Sheet = excel.Typed(ENpcResident);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Singular", "Adjective", "Plural", "PossessivePronoun", "StartsWithVowel", "Countability", "Pronoun", "Article", "Title", "Map", "Unknown1" };

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn title(self: @This()) []const u8 {
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

pub fn map(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(21, 0);
}
