//! `PvPInitialSelectActionTrait`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPInitialSelectActionTrait = @This();

pub const sheet_name = "PvPInitialSelectActionTrait";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6be0e840;
pub const Sheet = excel.Typed(PvPInitialSelectActionTrait);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}
