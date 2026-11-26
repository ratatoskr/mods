//! `AOZContentBriefingBNpc`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `BNpcName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZContentBriefingBNpc = @This();

pub const sheet_name = "AOZContentBriefingBNpc";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfc0810d7;
pub const Sheet = excel.Typed(AOZContentBriefingBNpc);

row: excel.Row,

/// Links to `BNpcName`.
pub fn bNpcName(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u32, 0));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn targetSmall(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn targetLarge(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn endurance(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn fire(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn ice(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn wind(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn earth(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn thunder(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn water(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn slashing(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn piercing(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn blunt(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn magic(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn hideStats(self: @This()) bool {
    return self.row.bitAt(23, 0);
}

pub fn slowVuln(self: @This()) bool {
    return self.row.bitAt(23, 1);
}

pub fn petrificationVuln(self: @This()) bool {
    return self.row.bitAt(23, 2);
}

pub fn paralysisVuln(self: @This()) bool {
    return self.row.bitAt(23, 3);
}

pub fn interruptionVuln(self: @This()) bool {
    return self.row.bitAt(23, 4);
}

pub fn blindVuln(self: @This()) bool {
    return self.row.bitAt(23, 5);
}

pub fn stunVuln(self: @This()) bool {
    return self.row.bitAt(23, 6);
}

pub fn sleepVuln(self: @This()) bool {
    return self.row.bitAt(23, 7);
}

pub fn bindVuln(self: @This()) bool {
    return self.row.bitAt(24, 0);
}

pub fn heavyVuln(self: @This()) bool {
    return self.row.bitAt(24, 1);
}

pub fn flatOrDeathVuln(self: @This()) bool {
    return self.row.bitAt(24, 2);
}
