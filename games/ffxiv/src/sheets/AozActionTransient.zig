//! `AozActionTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Icon`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AozActionTransient = @This();

pub const sheet_name = "AozActionTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4921bb28;
pub const Sheet = excel.Typed(AozActionTransient);

row: excel.Row,

pub fn stats(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// Links to `Quest`.
pub fn requiredForQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 12));
}

/// Links to `Quest`.
pub fn previousQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 16));
}

/// Links by `LocationKey`: 1 to `PlaceName`, 4 to `ContentFinderCondition`.
pub fn location(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn number(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn locationKey(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn targetsEnemy(self: @This()) bool {
    return self.row.bitAt(24, 0);
}

pub fn targetsSelfOrAlly(self: @This()) bool {
    return self.row.bitAt(24, 1);
}

pub fn causeSlow(self: @This()) bool {
    return self.row.bitAt(24, 2);
}

pub fn causePetrify(self: @This()) bool {
    return self.row.bitAt(24, 3);
}

pub fn causeParalysis(self: @This()) bool {
    return self.row.bitAt(24, 4);
}

pub fn causeInterrupt(self: @This()) bool {
    return self.row.bitAt(24, 5);
}

pub fn causeBlind(self: @This()) bool {
    return self.row.bitAt(24, 6);
}

pub fn causeStun(self: @This()) bool {
    return self.row.bitAt(24, 7);
}

pub fn causeSleep(self: @This()) bool {
    return self.row.bitAt(25, 0);
}

pub fn causeBind(self: @This()) bool {
    return self.row.bitAt(25, 1);
}

pub fn causeHeavy(self: @This()) bool {
    return self.row.bitAt(25, 2);
}

pub fn causeDeath(self: @This()) bool {
    return self.row.bitAt(25, 3);
}
