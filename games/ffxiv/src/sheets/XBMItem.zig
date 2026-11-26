//! `XBMItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMItem = @This();

pub const sheet_name = "XBMItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc37e7382;
pub const Sheet = excel.Typed(XBMItem);

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

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn shortDescription(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn adjective(self: @This()) i8 {
    return self.row.at(i8, 20);
}

pub fn possessivePronoun(self: @This()) i8 {
    return self.row.at(i8, 21);
}

pub fn startsWithVowel(self: @This()) i8 {
    return self.row.at(i8, 22);
}

pub fn countability(self: @This()) i8 {
    return self.row.at(i8, 23);
}

pub fn pronoun(self: @This()) i8 {
    return self.row.at(i8, 24);
}

pub fn article(self: @This()) i8 {
    return self.row.at(i8, 25);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn sellPrice(self: @This()) u16 {
    return self.row.at(u16, 32);
}

/// Links to `XBMItemType`.
pub fn @"type"(self: @This()) excel.Link(sheets.XBMItemType) {
    return .of(self.row.at(u8, 34));
}
