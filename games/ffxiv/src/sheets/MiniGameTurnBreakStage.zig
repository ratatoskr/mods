//! `MiniGameTurnBreakStage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MiniGameTurnBreakStage = @This();

pub const sheet_name = "MiniGameTurnBreakStage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc9ef8fad;
pub const Sheet = excel.Typed(MiniGameTurnBreakStage);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 10);
}
