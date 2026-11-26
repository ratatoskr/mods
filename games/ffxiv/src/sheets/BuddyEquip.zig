//! `BuddyEquip`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BuddyEquip = @This();

pub const sheet_name = "BuddyEquip";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb429792a;
pub const Sheet = excel.Typed(BuddyEquip);

row: excel.Row,

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

pub fn modelTop(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn modelBody(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn modelLegs(self: @This()) i32 {
    return self.row.at(i32, 28);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconHead(self: @This()) u16 {
    return self.row.at(u16, 32);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconBody(self: @This()) u16 {
    return self.row.at(u16, 34);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconLegs(self: @This()) u16 {
    return self.row.at(u16, 36);
}

/// Links to `GrandCompany`.
pub fn grandCompany(self: @This()) excel.Link(sheets.GrandCompany) {
    return .of(self.row.at(u8, 38));
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 39);
}
