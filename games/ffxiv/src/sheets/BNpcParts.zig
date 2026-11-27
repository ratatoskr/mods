//! `BNpcParts`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BNpcParts = @This();

pub const sheet_name = "BNpcParts";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbb3721b5;
pub const Sheet = excel.Typed(BNpcParts);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown36", "BNpcBase1", "PartSlot1", "Unknown12", "Unknown18", "Unknown24", "Unknown30", "X1", "Y1", "Z1", "Unknown6", "Scale1", "BNpcBase2", "PartSlot2", "Unknown13", "Unknown19", "Unknown25", "Unknown31", "X2", "Y2", "Z2", "Unknown7", "Scale2", "BNpcBase3", "PartSlot3", "Unknown14", "Unknown20", "Unknown26", "Unknown32", "X3", "Y3", "Z3", "Scale3", "Unknown3", "BNpcBase4", "PartSlot4", "Unknown15", "Unknown21", "Unknown27", "Unknown33", "X4", "Y4", "Z4", "Unknown8", "Scale4", "BNpcBase5", "PartSlot5", "Unknown16", "Unknown22", "Unknown28", "Unknown34", "X5", "Y5", "Z5", "Unknown9", "Scale5", "Unknown5", "Unknown11", "Unknown17", "Unknown23", "Unknown29", "Unknown35", "Unknown0", "Unknown1", "Unknown2", "Unknown10", "Unknown4" };

pub fn x1(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn x2(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn x3(self: @This()) f32 {
    return self.row.at(f32, 8);
}

pub fn x4(self: @This()) f32 {
    return self.row.at(f32, 12);
}

pub fn x5(self: @This()) f32 {
    return self.row.at(f32, 16);
}

pub fn unknown0(self: @This()) f32 {
    return self.row.at(f32, 20);
}

pub fn y1(self: @This()) f32 {
    return self.row.at(f32, 24);
}

pub fn y2(self: @This()) f32 {
    return self.row.at(f32, 28);
}

pub fn y3(self: @This()) f32 {
    return self.row.at(f32, 32);
}

pub fn y4(self: @This()) f32 {
    return self.row.at(f32, 36);
}

pub fn y5(self: @This()) f32 {
    return self.row.at(f32, 40);
}

pub fn unknown1(self: @This()) f32 {
    return self.row.at(f32, 44);
}

pub fn z1(self: @This()) f32 {
    return self.row.at(f32, 48);
}

pub fn z2(self: @This()) f32 {
    return self.row.at(f32, 52);
}

pub fn z3(self: @This()) f32 {
    return self.row.at(f32, 56);
}

pub fn z4(self: @This()) f32 {
    return self.row.at(f32, 60);
}

pub fn z5(self: @This()) f32 {
    return self.row.at(f32, 64);
}

pub fn unknown2(self: @This()) f32 {
    return self.row.at(f32, 68);
}

pub fn scale1(self: @This()) f32 {
    return self.row.at(f32, 72);
}

pub fn scale2(self: @This()) f32 {
    return self.row.at(f32, 76);
}

pub fn unknown3(self: @This()) f32 {
    return self.row.at(f32, 80);
}

pub fn scale4(self: @This()) f32 {
    return self.row.at(f32, 84);
}

pub fn scale5(self: @This()) f32 {
    return self.row.at(f32, 88);
}

pub fn unknown4(self: @This()) f32 {
    return self.row.at(f32, 92);
}

/// Links to `BNpcBase`.
pub fn bNpcBase1(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u16, 96));
}

/// Links to `BNpcBase`.
pub fn bNpcBase2(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u16, 98));
}

/// Links to `BNpcBase`.
pub fn bNpcBase3(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u16, 100));
}

/// Links to `BNpcBase`.
pub fn bNpcBase4(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u16, 102));
}

/// Links to `BNpcBase`.
pub fn bNpcBase5(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u16, 104));
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 106);
}

pub fn unknown6(self: @This()) i16 {
    return self.row.at(i16, 108);
}

pub fn unknown7(self: @This()) i16 {
    return self.row.at(i16, 110);
}

pub fn scale3(self: @This()) i16 {
    return self.row.at(i16, 112);
}

pub fn unknown8(self: @This()) i16 {
    return self.row.at(i16, 114);
}

pub fn unknown9(self: @This()) i16 {
    return self.row.at(i16, 116);
}

pub fn unknown10(self: @This()) i16 {
    return self.row.at(i16, 118);
}

pub fn partSlot1(self: @This()) u8 {
    return self.row.at(u8, 120);
}

pub fn partSlot2(self: @This()) u8 {
    return self.row.at(u8, 121);
}

pub fn partSlot3(self: @This()) u8 {
    return self.row.at(u8, 122);
}

pub fn partSlot4(self: @This()) u8 {
    return self.row.at(u8, 123);
}

pub fn partSlot5(self: @This()) u8 {
    return self.row.at(u8, 124);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 125);
}

pub fn unknown12(self: @This()) bool {
    return self.row.at(u8, 126) != 0;
}

pub fn unknown13(self: @This()) bool {
    return self.row.at(u8, 127) != 0;
}

pub fn unknown14(self: @This()) bool {
    return self.row.at(u8, 128) != 0;
}

pub fn unknown15(self: @This()) bool {
    return self.row.at(u8, 129) != 0;
}

pub fn unknown16(self: @This()) bool {
    return self.row.at(u8, 130) != 0;
}

pub fn unknown17(self: @This()) bool {
    return self.row.at(u8, 131) != 0;
}

pub fn unknown18(self: @This()) bool {
    return self.row.at(u8, 132) != 0;
}

pub fn unknown19(self: @This()) bool {
    return self.row.at(u8, 133) != 0;
}

pub fn unknown20(self: @This()) bool {
    return self.row.at(u8, 134) != 0;
}

pub fn unknown21(self: @This()) bool {
    return self.row.at(u8, 135) != 0;
}

pub fn unknown22(self: @This()) bool {
    return self.row.at(u8, 136) != 0;
}

pub fn unknown23(self: @This()) bool {
    return self.row.at(u8, 137) != 0;
}

pub fn unknown24(self: @This()) bool {
    return self.row.at(u8, 138) != 0;
}

pub fn unknown25(self: @This()) bool {
    return self.row.at(u8, 139) != 0;
}

pub fn unknown26(self: @This()) bool {
    return self.row.at(u8, 140) != 0;
}

pub fn unknown27(self: @This()) bool {
    return self.row.at(u8, 141) != 0;
}

pub fn unknown28(self: @This()) bool {
    return self.row.at(u8, 142) != 0;
}

pub fn unknown29(self: @This()) bool {
    return self.row.at(u8, 143) != 0;
}

pub fn unknown30(self: @This()) bool {
    return self.row.at(u8, 144) != 0;
}

pub fn unknown31(self: @This()) bool {
    return self.row.at(u8, 145) != 0;
}

pub fn unknown32(self: @This()) bool {
    return self.row.at(u8, 146) != 0;
}

pub fn unknown33(self: @This()) bool {
    return self.row.at(u8, 147) != 0;
}

pub fn unknown34(self: @This()) bool {
    return self.row.at(u8, 148) != 0;
}

pub fn unknown35(self: @This()) bool {
    return self.row.at(u8, 149) != 0;
}

pub fn unknown36(self: @This()) bool {
    return self.row.bitAt(150, 0);
}
