//! `EquipSlotCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EquipSlotCategory = @This();

pub const sheet_name = "EquipSlotCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf4ab6454;
pub const Sheet = excel.Typed(EquipSlotCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "MainHand", "OffHand", "Head", "Body", "Gloves", "Waist", "Legs", "Feet", "Ears", "Neck", "Wrists", "FingerL", "FingerR", "SoulCrystal" };

pub fn mainHand(self: @This()) i8 {
    return self.row.at(i8, 0);
}

pub fn offHand(self: @This()) i8 {
    return self.row.at(i8, 1);
}

pub fn head(self: @This()) i8 {
    return self.row.at(i8, 2);
}

pub fn body(self: @This()) i8 {
    return self.row.at(i8, 3);
}

pub fn gloves(self: @This()) i8 {
    return self.row.at(i8, 4);
}

pub fn waist(self: @This()) i8 {
    return self.row.at(i8, 5);
}

pub fn legs(self: @This()) i8 {
    return self.row.at(i8, 6);
}

pub fn feet(self: @This()) i8 {
    return self.row.at(i8, 7);
}

pub fn ears(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub fn neck(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn wrists(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn fingerL(self: @This()) i8 {
    return self.row.at(i8, 11);
}

pub fn fingerR(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn soulCrystal(self: @This()) i8 {
    return self.row.at(i8, 13);
}
