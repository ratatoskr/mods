//! `NpcEquip`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const NpcEquip = @This();

pub const sheet_name = "NpcEquip";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7eaeb95c;
pub const Sheet = excel.Typed(NpcEquip);

row: excel.Row,

pub fn modelMainHand(self: @This()) u64 {
    return self.row.at(u64, 0);
}

pub fn modelOffHand(self: @This()) u64 {
    return self.row.at(u64, 8);
}

pub fn modelHead(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn modelBody(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn modelHands(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn modelLegs(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn modelFeet(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn modelEars(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn modelNeck(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn modelWrists(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn modelLeftRing(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn modelRightRing(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub const glasses_len = 2;
/// Links to `Glasses`.
pub fn glasses(self: @This(), n0: usize) excel.Link(sheets.Glasses) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

/// Links to `Stain`.
pub fn dyeMainHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 60));
}

/// Links to `Stain`.
pub fn dye2MainHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 61));
}

/// Links to `Stain`.
pub fn dyeOffHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 62));
}

/// Links to `Stain`.
pub fn dye2OffHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 63));
}

/// Links to `Stain`.
pub fn dyeHead(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 64));
}

/// Links to `Stain`.
pub fn dyeBody(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 65));
}

/// Links to `Stain`.
pub fn dyeHands(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 66));
}

/// Links to `Stain`.
pub fn dyeLegs(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 67));
}

/// Links to `Stain`.
pub fn dyeFeet(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 68));
}

/// Links to `Stain`.
pub fn dyeEars(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 69));
}

/// Links to `Stain`.
pub fn dyeNeck(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 70));
}

/// Links to `Stain`.
pub fn dyeWrists(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 71));
}

/// Links to `Stain`.
pub fn dyeLeftRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 72));
}

/// Links to `Stain`.
pub fn dyeRightRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 73));
}

/// Links to `Stain`.
pub fn dye2Head(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 74));
}

/// Links to `Stain`.
pub fn dye2Body(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 75));
}

/// Links to `Stain`.
pub fn dye2Hands(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 76));
}

/// Links to `Stain`.
pub fn dye2Legs(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 77));
}

/// Links to `Stain`.
pub fn dye2Feet(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 78));
}

/// Links to `Stain`.
pub fn dye2Ears(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 79));
}

/// Links to `Stain`.
pub fn dye2Neck(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 80));
}

/// Links to `Stain`.
pub fn dye2Wrists(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 81));
}

/// Links to `Stain`.
pub fn dye2LeftRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 82));
}

/// Links to `Stain`.
pub fn dye2RightRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 83));
}

pub fn visor(self: @This()) bool {
    return self.row.bitAt(84, 0);
}

pub fn visorToggled(self: @This()) bool {
    return self.row.bitAt(84, 1);
}

const offsets_1 = [2]u16{ 56, 58 };
