//! `TripleTriadCardResident`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TripleTriadCardResident = @This();

pub const sheet_name = "TripleTriadCardResident";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x996e0a5e;
pub const Sheet = excel.Typed(TripleTriadCardResident);

row: excel.Row,

/// Links by `AcquisitionType`: 2 to `ContentFinderCondition`, 3 to `ContentFinderCondition`, 4 to `Fate`, 5 to `Fate`, 6 to `ENpcResident`, 8 to `Item`, 9 to `Item`, 10 to `ENpcResident`, 11 to `Achievement`, 12 to `ContentFinderCondition`.
pub fn acquisition(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links by `AcquisitionType`: 4 to `TerritoryType`, 5 to `TerritoryType`, 6 to `Level`, 10 to `Level`.
pub fn location(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 8));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn saleValue(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn top(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn bottom(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn left(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn right(self: @This()) u8 {
    return self.row.at(u8, 21);
}

/// Links to `TripleTriadCardRarity`.
pub fn tripleTriadCardRarity(self: @This()) excel.Link(sheets.TripleTriadCardRarity) {
    return .of(self.row.at(u8, 22));
}

/// Links to `TripleTriadCardType`.
pub fn tripleTriadCardType(self: @This()) excel.Link(sheets.TripleTriadCardType) {
    return .of(self.row.at(u8, 23));
}

pub fn sortKey(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn uiPriority(self: @This()) u8 {
    return self.row.at(u8, 25);
}

/// Links to `TripleTriadCardObtain`.
pub fn acquisitionType(self: @This()) excel.Link(sheets.TripleTriadCardObtain) {
    return .of(self.row.at(u8, 26));
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(27, 0);
}
