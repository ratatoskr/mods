//! `BenchmarkOverrideEquipment`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BenchmarkOverrideEquipment = @This();

pub const sheet_name = "BenchmarkOverrideEquipment";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd0ed99de;
pub const Sheet = excel.Typed(BenchmarkOverrideEquipment);

row: excel.Row,

pub fn modelMainHand(self: @This()) u64 {
    return self.row.at(u64, 0);
}

pub fn modelOffHand(self: @This()) u64 {
    return self.row.at(u64, 8);
}

pub fn unknown0(self: @This()) u64 {
    return self.row.at(u64, 16);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn modelHead(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn modelBody(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn modelHands(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn modelLegs(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn modelFeet(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn modelEars(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub fn modelNeck(self: @This()) u32 {
    return self.row.at(u32, 56);
}

pub fn modelWrists(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn modelLeftRing(self: @This()) u32 {
    return self.row.at(u32, 64);
}

pub fn modelRightRing(self: @This()) u32 {
    return self.row.at(u32, 68);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 72);
}

/// Links to `Stain`.
pub fn dyeMainHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 73));
}

/// Links to `Stain`.
pub fn dyeOffHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 74));
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 75);
}

/// Links to `Stain`.
pub fn dyeHead(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 76));
}

/// Links to `Stain`.
pub fn dyeBody(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 77));
}

/// Links to `Stain`.
pub fn dyeHands(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 78));
}

/// Links to `Stain`.
pub fn dyeLegs(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 79));
}

/// Links to `Stain`.
pub fn dyeFeet(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 80));
}

/// Links to `Stain`.
pub fn dyeEars(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 81));
}

/// Links to `Stain`.
pub fn dyeNeck(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 82));
}

/// Links to `Stain`.
pub fn dyeWrists(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 83));
}

/// Links to `Stain`.
pub fn dyeLeftRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 84));
}

/// Links to `Stain`.
pub fn dyeRightRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 85));
}

pub fn unknown5(self: @This()) i8 {
    return self.row.at(i8, 86);
}
