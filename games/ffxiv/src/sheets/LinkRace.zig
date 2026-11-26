//! `LinkRace`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LinkRace = @This();

pub const sheet_name = "LinkRace";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3836c798;
pub const Sheet = excel.Typed(LinkRace);

row: excel.Row,

pub fn unknown0(self: @This()) bool {
    return self.row.at(u8, 0) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 1) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 2) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 3) != 0;
}
