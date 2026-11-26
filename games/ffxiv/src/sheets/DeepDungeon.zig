//! `DeepDungeon`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeon = @This();

pub const sheet_name = "DeepDungeon";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xed6590ef;
pub const Sheet = excel.Typed(DeepDungeon);

row: excel.Row,

pub const pomander_slot_len = 16;
/// Links to `DeepDungeonItem`.
pub fn pomanderSlot(self: @This(), n0: usize) excel.Link(sheets.DeepDungeonItem) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 32);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 36);
}

pub fn unknown8(self: @This()) u32 {
    return self.row.at(u32, 40);
}

pub fn unknown9(self: @This()) u32 {
    return self.row.at(u32, 44);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 48);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 49);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 50);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 51);
}

pub const magicite_slot_len = 4;
/// Links by `DeepDungeonType`: 1 to `DeepDungeonMagicStone`, 2 to `DeepDungeonDemiclone`.
pub fn magiciteSlot(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(56);
}

pub fn unknown14(self: @This()) u32 {
    return self.row.at(u32, 60);
}

/// Links to `DeepDungeonEquipment`.
pub fn aetherpoolArm(self: @This()) excel.Link(sheets.DeepDungeonEquipment) {
    return .of(self.row.at(u8, 64));
}

/// Links to `DeepDungeonEquipment`.
pub fn aetherpoolArmor(self: @This()) excel.Link(sheets.DeepDungeonEquipment) {
    return .of(self.row.at(u8, 65));
}

pub fn deepDungeonType(self: @This()) u8 {
    return self.row.at(u8, 66);
}

const offsets_1 = [16]u16{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 };
const offsets_2 = [4]u16{ 52, 53, 54, 55 };
