//! `Treasure`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `SGB`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Treasure = @This();

pub const sheet_name = "Treasure";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbc8c78db;
pub const Sheet = excel.Typed(Treasure);

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

/// Links to `ExportedSG`.
pub fn sgb(self: @This()) excel.Link(sheets.ExportedSG) {
    return .of(self.row.at(u32, 16));
}

pub fn unknown_70(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(21, 0);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(21, 1);
}
