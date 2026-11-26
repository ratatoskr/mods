//! `BNpcBase`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BNpcBase = @This();

pub const sheet_name = "BNpcBase";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xad223303;
pub const Sheet = excel.Typed(BNpcBase);

row: excel.Row,

pub fn scale(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn unknown11(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `ArrayEventHandler`.
pub fn arrayEventHandler(self: @This()) excel.Link(sheets.ArrayEventHandler) {
    return .of(self.row.at(i32, 8));
}

/// Links to `Behavior`.
pub fn behavior(self: @This()) excel.Link(sheets.Behavior) {
    return .of(self.row.at(u16, 12));
}

/// Links to `ModelChara`.
pub fn modelChara(self: @This()) excel.Link(sheets.ModelChara) {
    return .of(self.row.at(u16, 14));
}

/// Links to `BNpcCustomize`.
pub fn bNpcCustomize(self: @This()) excel.Link(sheets.BNpcCustomize) {
    return .of(self.row.at(u16, 16));
}

/// Links to `NpcEquip`.
pub fn npcEquip(self: @This()) excel.Link(sheets.NpcEquip) {
    return .of(self.row.at(u16, 18));
}

pub fn special(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 22);
}

/// Links to `Battalion`.
pub fn battalion(self: @This()) excel.Link(sheets.Battalion) {
    return .of(self.row.at(u8, 24));
}

/// Links to `LinkRace`.
pub fn linkRace(self: @This()) excel.Link(sheets.LinkRace) {
    return .of(self.row.at(u8, 25));
}

pub fn rank(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn sePack(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 28);
}

/// Links to `BNpcParts`.
pub fn bNpcParts(self: @This()) excel.Link(sheets.BNpcParts) {
    return .of(self.row.at(u8, 29));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 34);
}

pub fn isOmnidirectional(self: @This()) bool {
    return self.row.bitAt(35, 0);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(35, 1);
}

pub fn isTargetLine(self: @This()) bool {
    return self.row.bitAt(35, 2);
}

pub fn isDisplayLevel(self: @This()) bool {
    return self.row.bitAt(35, 3);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(35, 4);
}

pub fn unknown_70(self: @This()) bool {
    return self.row.bitAt(35, 5);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(35, 6);
}
