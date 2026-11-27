//! `MandervilleWeaponEnhance`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MandervilleWeaponEnhance = @This();

pub const sheet_name = "MandervilleWeaponEnhance";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9ec26187;
pub const Sheet = excel.Typed(MandervilleWeaponEnhance);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown7", "Materia[0]", "MateriaBigValueIndex[0]", "MateriaSmallValueIndex[0]", "Materia[1]", "MateriaBigValueIndex[1]", "MateriaSmallValueIndex[1]", "Materia[2]", "MateriaBigValueIndex[2]", "MateriaSmallValueIndex[2]", "Materia[3]", "MateriaBigValueIndex[3]", "MateriaSmallValueIndex[3]", "UpgradeItem", "UpgradeCost", "Image" };

pub const materia_len = 4;
/// Links to `Materia`.
pub fn materia(self: @This(), n0: usize) excel.Link(sheets.Materia) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

/// Links to `Item`.
pub fn upgradeItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 16));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn upgradeCost(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub const materia_big_value_index_len = 4;
pub fn materiaBigValueIndex(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub const materia_small_value_index_len = 4;
pub fn materiaSmallValueIndex(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_3[n0]);
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
const offsets_2 = [4]u16{ 27, 28, 29, 30 };
const offsets_3 = [4]u16{ 31, 32, 33, 34 };
