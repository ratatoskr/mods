//! `GcArmyTraining`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GcArmyTraining = @This();

pub const sheet_name = "GcArmyTraining";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x274780bb;
pub const Sheet = excel.Typed(GcArmyTraining);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn experience(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn physicalBonus(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn mentalBonus(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn tacticalBonus(self: @This()) i8 {
    return self.row.at(i8, 14);
}
