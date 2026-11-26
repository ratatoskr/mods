//! `Glasses`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Glasses = @This();

pub const sheet_name = "Glasses";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2faac2c1;
pub const Sheet = excel.Typed(Glasses);

row: excel.Row,

pub fn singular(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn plural(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn name(self: @This()) []const u8 {
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

pub fn model(self: @This()) u32 {
    return self.row.at(u32, 24);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 28);
}

pub fn unknown_70_8(self: @This()) u16 {
    return self.row.at(u16, 32);
}

/// Links to `GlassesStyle`.
pub fn style(self: @This()) excel.Link(sheets.GlassesStyle) {
    return .of(self.row.at(i16, 34));
}
