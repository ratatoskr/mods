//! `ChocoboRaceAbility`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceAbility = @This();

pub const sheet_name = "ChocoboRaceAbility";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc68f9e95;
pub const Sheet = excel.Typed(ChocoboRaceAbility);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn value(self: @This()) u8 {
    return self.row.at(u8, 12);
}

/// Links to `ChocoboRaceAbilityType`.
pub fn chocoboRaceAbilityType(self: @This()) excel.Link(sheets.ChocoboRaceAbilityType) {
    return .of(self.row.at(i8, 13));
}
