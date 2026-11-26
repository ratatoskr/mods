//! `GcArmyExpeditionTrait`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyExpeditionTrait = @This();

pub const sheet_name = "GcArmyExpeditionTrait";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x22890955;
pub const Sheet = excel.Typed(GcArmyExpeditionTrait);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 13);
}
