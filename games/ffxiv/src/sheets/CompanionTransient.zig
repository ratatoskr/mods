//! `CompanionTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Description`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanionTransient = @This();

pub const sheet_name = "CompanionTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xea0b06cf;
pub const Sheet = excel.Typed(CompanionTransient);

row: excel.Row,

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn descriptionEnhanced(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn tooltip(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn specialActionName(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn specialActionDescription(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn attack(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn defense(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn speed(self: @This()) u8 {
    return self.row.at(u8, 22);
}

/// Links to `MinionSkillType`.
pub fn minionSkillType(self: @This()) excel.Link(sheets.MinionSkillType) {
    return .of(self.row.at(u8, 23));
}

pub fn hasAreaAttack(self: @This()) bool {
    return self.row.bitAt(24, 0);
}

pub fn strengthGate(self: @This()) bool {
    return self.row.bitAt(24, 1);
}

pub fn strengthEye(self: @This()) bool {
    return self.row.bitAt(24, 2);
}

pub fn strengthShield(self: @This()) bool {
    return self.row.bitAt(24, 3);
}

pub fn strengthArcana(self: @This()) bool {
    return self.row.bitAt(24, 4);
}
