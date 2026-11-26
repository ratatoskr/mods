//! `Ornament`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Ornament = @This();

pub const sheet_name = "Ornament";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3d312c8f;
pub const Sheet = excel.Typed(Ornament);

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

pub fn model(self: @This()) u16 {
    return self.row.at(u16, 16);
}

/// Links to `OrnamentAction`.
pub fn action(self: @This()) excel.Link(sheets.OrnamentAction) {
    return .of(self.row.at(u16, 18));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn transient(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn order(self: @This()) i16 {
    return self.row.at(i16, 24);
}

/// Links to `OrnamentCustomizeGroup`.
pub fn customizeGroup(self: @This()) excel.Link(sheets.OrnamentCustomizeGroup) {
    return .of(self.row.at(u8, 26));
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 28);
}
