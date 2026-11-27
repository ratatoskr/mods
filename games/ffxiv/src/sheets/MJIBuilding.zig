//! `MJIBuilding`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIBuilding = @This();

pub const sheet_name = "MJIBuilding";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x6d809733;
pub const Sheet = excel.Typed(MJIBuilding);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Sgb[0]", "Unknown2", "Unknown3", "Sgb[1]", "Unknown4", "Sgb[2]", "Unknown5", "Sgb[3]", "Unknown6", "Sgb[4]", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13", "Unknown14", "Material[0]", "Material[1]", "Material[2]", "Material[3]", "Material[4]", "Amount[0]", "Amount[1]", "Amount[2]", "Amount[3]", "Amount[4]", "Name", "Unknown0", "Icon" };

/// Links to `MJIText`.
pub fn name(self: @This()) excel.Link(sheets.MJIText) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub const sgb_len = 5;
/// Links to `ExportedSG`.
pub fn sgb(self: @This(), n0: usize) excel.Link(sheets.ExportedSG) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 25);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 26);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 27);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 31);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 32);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 33);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 34);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 35);
}

pub const material_len = 5;
/// Links to `MJIItemPouch`.
pub fn material(self: @This(), n0: usize) excel.Link(sheets.MJIItemPouch) {
    return .of(self.row.at(u8, offsets_2[n0]));
}

pub const amount_len = 5;
pub fn amount(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_3[n0]);
}

const offsets_1 = [5]u16{ 12, 14, 16, 18, 20 };
const offsets_2 = [5]u16{ 36, 37, 38, 39, 40 };
const offsets_3 = [5]u16{ 41, 42, 43, 44, 45 };
