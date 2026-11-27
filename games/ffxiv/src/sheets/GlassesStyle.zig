//! `GlassesStyle`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GlassesStyle = @This();

pub const sheet_name = "GlassesStyle";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc138bb6e;
pub const Sheet = excel.Typed(GlassesStyle);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "GlassesSlot", "Icon", "Order", "Glasses[0]", "Glasses[1]", "Glasses[2]", "Glasses[3]", "Glasses[4]", "Glasses[5]", "Glasses[6]", "Glasses[7]", "Glasses[8]", "Glasses[9]", "Glasses[10]", "Glasses[11]", "Singular", "Adjective", "Plural", "PossessivePronoun", "StartsWithVowel", "Countability", "Pronoun", "Article", "Name" };

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn name(self: @This()) []const u8 {
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

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub const glasses_len = 12;
/// Links to `Glasses`.
pub fn glasses(self: @This(), n0: usize) excel.Link(sheets.Glasses) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn glassesSlot(self: @This()) i16 {
    return self.row.at(i16, 50);
}

const offsets_1 = [12]u16{ 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48 };
