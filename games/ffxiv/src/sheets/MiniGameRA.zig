//! `MiniGameRA`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MiniGameRA = @This();

pub const sheet_name = "MiniGameRA";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x59d9cace;
pub const Sheet = excel.Typed(MiniGameRA);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Icon", "Image", "BGM", "Unknown2", "Unknown14", "Unknown15", "Unknown0", "Unknown16", "Unknown17", "Unknown18", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown10", "Unknown11", "Unknown12", "Unknown13" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 12);
}

/// Links to `BGM`.
pub fn bgm(self: @This()) excel.Link(sheets.BGM) {
    return .of(self.row.at(i32, 16));
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn unknown6(self: @This()) i16 {
    return self.row.at(i16, 30);
}

pub fn unknown7(self: @This()) i16 {
    return self.row.at(i16, 32);
}

pub fn unknown8(self: @This()) i16 {
    return self.row.at(i16, 34);
}

pub fn unknown9(self: @This()) i16 {
    return self.row.at(i16, 36);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 38);
}

pub fn unknown11(self: @This()) u8 {
    return self.row.at(u8, 39);
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn unknown13(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub fn unknown14(self: @This()) bool {
    return self.row.bitAt(42, 0);
}

pub fn unknown15(self: @This()) bool {
    return self.row.bitAt(42, 1);
}

pub fn unknown16(self: @This()) bool {
    return self.row.bitAt(42, 2);
}

pub fn unknown17(self: @This()) bool {
    return self.row.bitAt(42, 3);
}

pub fn unknown18(self: @This()) bool {
    return self.row.bitAt(42, 4);
}
