//! `GcArmyProgress`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyProgress = @This();

pub const sheet_name = "GcArmyProgress";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd9d08a48;
pub const Sheet = excel.Typed(GcArmyProgress);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 4);
}
