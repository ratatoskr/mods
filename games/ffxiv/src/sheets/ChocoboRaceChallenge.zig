//! `ChocoboRaceChallenge`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceChallenge = @This();

pub const sheet_name = "ChocoboRaceChallenge";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xea97d93a;
pub const Sheet = excel.Typed(ChocoboRaceChallenge);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `ChocoboRace`.
pub fn chocoboRace(self: @This()) excel.Link(sheets.ChocoboRace) {
    return .of(self.row.at(u16, 4));
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn ratingRequirement(self: @This()) u16 {
    return self.row.at(u16, 8);
}
