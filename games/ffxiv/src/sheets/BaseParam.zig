//! `BaseParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BaseParam = @This();

pub const sheet_name = "BaseParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1bf83f1f;
pub const Sheet = excel.Typed(BaseParam);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn oneHandWeaponPercent(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn offHandPercent(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn headPercent(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn chestPercent(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn handsPercent(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn waistPercent(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn legsPercent(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn feetPercent(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn earringPercent(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn necklacePercent(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn braceletPercent(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn ringPercent(self: @This()) u16 {
    return self.row.at(u16, 30);
}

pub fn twoHandWeaponPercent(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn underArmorPercent(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn chestHeadPercent(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn chestHeadLegsFeetPercent(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn legsFeetPercent(self: @This()) u16 {
    return self.row.at(u16, 42);
}

pub fn headChestHandsLegsFeetPercent(self: @This()) u16 {
    return self.row.at(u16, 44);
}

pub fn chestLegsGlovesPercent(self: @This()) u16 {
    return self.row.at(u16, 46);
}

pub fn chestLegsFeetPercent(self: @This()) u16 {
    return self.row.at(u16, 48);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 50);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 52);
}

pub fn orderPriority(self: @This()) u8 {
    return self.row.at(u8, 54);
}

pub const meld_param_len = 13;
pub fn meldParam(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_1[n0]);
}

pub fn packetIndex(self: @This()) i8 {
    return self.row.at(i8, 68);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(69, 0);
}

const offsets_1 = [13]u16{ 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 };
