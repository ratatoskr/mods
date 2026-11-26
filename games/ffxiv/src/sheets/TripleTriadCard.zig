//! `TripleTriadCard`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TripleTriadCard = @This();

pub const sheet_name = "TripleTriadCard";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x45c06ae0;
pub const Sheet = excel.Typed(TripleTriadCard);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn unknown2(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn startsWithVowel(self: @This()) i8 {
    return self.row.at(i8, 14);
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 15);
}

pub fn unknown4(self: @This()) i8 {
    return self.row.at(i8, 16);
}

pub fn unknown5(self: @This()) i8 {
    return self.row.at(i8, 17);
}
