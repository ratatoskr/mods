//! `CSBonusSeason`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CSBonusSeason = @This();

pub const sheet_name = "CSBonusSeason";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfa932392;
pub const Sheet = excel.Typed(CSBonusSeason);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Currency1", "Currency2", "Category0", "Unknown14", "Category1", "Unknown15", "Category2", "Unknown16", "Category3", "Unknown17", "Text0", "Text1", "Unknown12" };

/// Links to `Item`.
pub fn currency1(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Item`.
pub fn currency2(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 4));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn category0(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn category1(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn category2(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn category3(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn unknown14(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown15(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown16(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown17(self: @This()) u16 {
    return self.row.at(u16, 26);
}

/// Links to `CSBonusTextData`.
pub fn text0(self: @This()) excel.Link(sheets.CSBonusTextData) {
    return .of(self.row.at(u8, 28));
}

/// Links to `CSBonusTextData`.
pub fn text1(self: @This()) excel.Link(sheets.CSBonusTextData) {
    return .of(self.row.at(u8, 29));
}

pub fn unknown12(self: @This()) u8 {
    return self.row.at(u8, 30);
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 31) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 32) != 0;
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(33, 0);
}
