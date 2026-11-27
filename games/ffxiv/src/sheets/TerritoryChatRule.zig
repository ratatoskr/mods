//! `TerritoryChatRule`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TerritoryChatRule = @This();

pub const sheet_name = "TerritoryChatRule";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd460be93;
pub const Sheet = excel.Typed(TerritoryChatRule);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown7", "Public", "Shout", "DutyTell", "PublicTell", "Party", "Global", "Pvp" };

pub fn public(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn shout(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn dutyTell(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn publicTell(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn party(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn global(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn pvp(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(7, 0);
}
