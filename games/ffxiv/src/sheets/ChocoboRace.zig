//! `ChocoboRace`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRace = @This();

pub const sheet_name = "ChocoboRace";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xde74b4c4;
pub const Sheet = excel.Typed(ChocoboRace);

row: excel.Row,

/// Links to `ChocoboRaceRank`.
pub fn chocoboRaceRank(self: @This()) excel.Link(sheets.ChocoboRaceRank) {
    return .of(self.row.at(u8, 0));
}

/// Links to `ChocoboRaceTerritory`.
pub fn chocoboRaceTerritory(self: @This()) excel.Link(sheets.ChocoboRaceTerritory) {
    return .of(self.row.at(u8, 1));
}
