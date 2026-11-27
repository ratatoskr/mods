//! `MJILandmark`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJILandmark = @This();

pub const sheet_name = "MJILandmark";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7b947615;
pub const Sheet = excel.Typed(MJILandmark);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Unknown3", "UnlockLink", "SGB[0]", "SGB[1]", "SGB[2]", "Unknown4", "SGB[3]", "Unknown5", "SGB[4]", "Unknown6", "SGB[5]", "Unknown7", "SGB[6]", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Material[0]", "Material[1]", "Material[2]", "Material[3]", "Material[4]", "Amount[0]", "Amount[1]", "Amount[2]", "Amount[3]", "Amount[4]", "Name", "Unknown1", "Icon" };

/// Links to `MJIText`.
pub fn name(self: @This()) excel.Link(sheets.MJIText) {
    return .of(self.row.at(u32, 0));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unlockLink(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub const sgb_len = 7;
/// Links to `ExportedSG`.
pub fn sgb(self: @This(), n0: usize) excel.Link(sheets.ExportedSG) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub const material_len = 5;
/// Links to `MJIItemPouch`.
pub fn material(self: @This(), n0: usize) excel.Link(sheets.MJIItemPouch) {
    return .of(self.row.at(u16, offsets_2[n0]));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 36);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 37);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 39);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 42);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 43);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 44);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 45);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 46);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 47);
}

pub const amount_len = 5;
pub fn amount(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_3[n0]);
}

const offsets_1 = [7]u16{ 10, 12, 14, 16, 18, 20, 22 };
const offsets_2 = [5]u16{ 24, 26, 28, 30, 32 };
const offsets_3 = [5]u16{ 48, 49, 50, 51, 52 };
