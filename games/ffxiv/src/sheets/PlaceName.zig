//! `PlaceName`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PlaceName = @This();

pub const sheet_name = "PlaceName";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x16a1fd3c;
pub const Sheet = excel.Typed(PlaceName);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn nameNoArticle(self: @This()) []const u8 {
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

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 22);
}

/// Links to `MapCondition`.
pub fn mapCondition(self: @This()) excel.Link(sheets.MapCondition) {
    return .of(self.row.at(u8, 23));
}
