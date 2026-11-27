//! `ModelChara`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ModelChara = @This();

pub const sheet_name = "ModelChara";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc5bb1bc4;
pub const Sheet = excel.Typed(ModelChara);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "Model", "Base", "Variant", "SEPack", "AnimationVariant", "Unknown7", "PapVariation", "Unknown3", "Unknown6", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown4", "Unknown13", "Unknown5", "Unknown14", "Radius", "Unknown1", "Unknown_70", "Unknown15" };

pub fn radius(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn unknown1(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn unknown15(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn model(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn sePack(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn base(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn variant(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn animationVariant(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown_70(self: @This()) u8 {
    return self.row.at(u8, 24);
}

pub fn unknown6(self: @This()) i8 {
    return self.row.at(i8, 25);
}

pub fn unknown7(self: @This()) bool {
    return self.row.bitAt(26, 0);
}

pub fn papVariation(self: @This()) bool {
    return self.row.bitAt(26, 1);
}

pub fn unknown8(self: @This()) bool {
    return self.row.bitAt(26, 2);
}

pub fn unknown9(self: @This()) bool {
    return self.row.bitAt(26, 3);
}

pub fn unknown10(self: @This()) bool {
    return self.row.bitAt(26, 4);
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(26, 5);
}

pub fn unknown12(self: @This()) bool {
    return self.row.bitAt(26, 6);
}

pub fn unknown13(self: @This()) bool {
    return self.row.bitAt(26, 7);
}
