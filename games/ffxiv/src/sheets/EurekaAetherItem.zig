//! `EurekaAetherItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Singular`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EurekaAetherItem = @This();

pub const sheet_name = "EurekaAetherItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x45c06ae0;
pub const Sheet = excel.Typed(EurekaAetherItem);

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
