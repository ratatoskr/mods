//! `DeepDungeonDemiclone`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `TitleCase`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeonDemiclone = @This();

pub const sheet_name = "DeepDungeonDemiclone";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc638f2bf;
pub const Sheet = excel.Typed(DeepDungeonDemiclone);

row: excel.Row,

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn titleCase(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn description(self: @This()) []const u8 {
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

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 24);
}
