//! `WKSDevGrade`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Stage`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSDevGrade = @This();

pub const sheet_name = "WKSDevGrade";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa1c00869;
pub const Sheet = excel.Typed(WKSDevGrade);

row: excel.Row,

pub fn stageFull(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn stage(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn indexText2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn indexText(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn indexNpc(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

/// The image displayed when entering the Cosmic Exploration zone on a server that is currently at this stage.
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn thumbnail(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown12(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown13(self: @This()) i32 {
    return self.row.at(i32, 32);
}

pub fn festivalId(self: @This()) u16 {
    return self.row.at(u16, 36);
}

pub fn unknown14(self: @This()) u16 {
    return self.row.at(u16, 38);
}

/// The rank for a world that is currently at this stage, as displayed on the Lodestone site, minus one.
pub fn lodestoneRank(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn festivalPhase(self: @This()) u8 {
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

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 46);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 47);
}

pub fn unknown17(self: @This()) u8 {
    return self.row.at(u8, 48);
}

pub fn unknown18(self: @This()) u8 {
    return self.row.at(u8, 49);
}

pub fn unknown19(self: @This()) u8 {
    return self.row.at(u8, 50);
}

pub fn unknown20(self: @This()) u8 {
    return self.row.at(u8, 51);
}

pub fn unknown21(self: @This()) u8 {
    return self.row.at(u8, 52);
}

pub fn unknown22(self: @This()) u8 {
    return self.row.at(u8, 53);
}

pub fn unknown23(self: @This()) u8 {
    return self.row.at(u8, 54);
}

pub fn unknown24(self: @This()) bool {
    return self.row.bitAt(55, 0);
}
