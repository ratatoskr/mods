//! `ENpcDressUpDress`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ENpcDressUpDress = @This();

pub const sheet_name = "ENpcDressUpDress";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xb07c9caa;
pub const Sheet = excel.Typed(ENpcDressUpDress);

row: excel.Row,

pub fn modelMainHand(self: @This()) u64 {
    return self.row.at(u64, 0);
}

pub fn modelOffHand(self: @This()) u64 {
    return self.row.at(u64, 8);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// Links to `ENpcResident`.
pub fn eNpc(self: @This()) excel.Link(sheets.ENpcResident) {
    return .of(self.row.at(u32, 20));
}

pub fn modelHead(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn modelBody(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn modelHands(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn modelLegs(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn modelFeet(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 48);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 52);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 56);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 60);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 64);
}

/// Links to `Behavior`.
pub fn behavior(self: @This()) excel.Link(sheets.Behavior) {
    return .of(self.row.at(u16, 66));
}

pub fn unknown7(self: @This()) u16 {
    return self.row.at(u16, 68);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 70);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 71);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 72);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 73);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 74);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 75);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 76);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 77);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 78);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 79);
}

pub fn unknown18(self: @This()) u8 {
    return self.row.at(u8, 80);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 81);
}

pub fn unknown20(self: @This()) u8 {
    return self.row.at(u8, 82);
}

pub fn unknown21(self: @This()) u8 {
    return self.row.at(u8, 83);
}

pub fn unknown22(self: @This()) u8 {
    return self.row.at(u8, 84);
}

pub fn unknown23(self: @This()) u8 {
    return self.row.at(u8, 85);
}

pub fn unknown24(self: @This()) u8 {
    return self.row.at(u8, 86);
}

pub fn unknown25(self: @This()) u8 {
    return self.row.at(u8, 87);
}

pub fn unknown26(self: @This()) u8 {
    return self.row.at(u8, 88);
}

pub fn unknown27(self: @This()) u8 {
    return self.row.at(u8, 89);
}

pub fn unknown28(self: @This()) u8 {
    return self.row.at(u8, 90);
}

pub fn unknown29(self: @This()) u8 {
    return self.row.at(u8, 91);
}

pub fn unknown30(self: @This()) u8 {
    return self.row.at(u8, 92);
}

pub fn unknown31(self: @This()) u8 {
    return self.row.at(u8, 93);
}

pub fn unknown32(self: @This()) u8 {
    return self.row.at(u8, 94);
}

pub fn unknown33(self: @This()) u8 {
    return self.row.at(u8, 95);
}

pub fn unknown34(self: @This()) u8 {
    return self.row.at(u8, 96);
}

/// Links to `Stain`.
pub fn dyeMainHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 97));
}

/// Links to `Stain`.
pub fn dye2MainHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 98));
}

/// Links to `Stain`.
pub fn dyeOffHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 99));
}

/// Links to `Stain`.
pub fn dye2OffHand(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 100));
}

/// Links to `Stain`.
pub fn dyeHead(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 101));
}

/// Links to `Stain`.
pub fn dyeBody(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 102));
}

/// Links to `Stain`.
pub fn dyeHands(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 103));
}

/// Links to `Stain`.
pub fn dyeLegs(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 104));
}

/// Links to `Stain`.
pub fn dyeFeet(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 105));
}

/// Links to `Stain`.
pub fn dyeEars(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 106));
}

/// Links to `Stain`.
pub fn dyeNeck(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 107));
}

/// Links to `Stain`.
pub fn dyeWrists(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 108));
}

/// Links to `Stain`.
pub fn dyeLeftRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 109));
}

/// Links to `Stain`.
pub fn dyeRightRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 110));
}

/// Links to `Stain`.
pub fn dye2Head(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 111));
}

/// Links to `Stain`.
pub fn dye2Body(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 112));
}

/// Links to `Stain`.
pub fn dye2Hands(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 113));
}

/// Links to `Stain`.
pub fn dye2Legs(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 114));
}

/// Links to `Stain`.
pub fn dye2Feet(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 115));
}

/// Links to `Stain`.
pub fn dye2Ears(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 116));
}

/// Links to `Stain`.
pub fn dye2Neck(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 117));
}

/// Links to `Stain`.
pub fn dye2Wrists(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 118));
}

/// Links to `Stain`.
pub fn dye2LeftRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 119));
}

/// Links to `Stain`.
pub fn dye2RightRing(self: @This()) excel.Link(sheets.Stain) {
    return .of(self.row.at(u8, 120));
}

pub fn unknown40(self: @This()) bool {
    return self.row.bitAt(121, 0);
}

pub fn unknown41(self: @This()) bool {
    return self.row.bitAt(121, 1);
}

pub fn unknown42(self: @This()) bool {
    return self.row.bitAt(121, 2);
}

pub fn unknown43(self: @This()) bool {
    return self.row.bitAt(121, 3);
}

pub fn unknown44(self: @This()) bool {
    return self.row.bitAt(121, 4);
}
