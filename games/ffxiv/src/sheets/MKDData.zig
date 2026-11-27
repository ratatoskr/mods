//! `MKDData`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MKDData = @This();

pub const sheet_name = "MKDData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0598096d;
pub const Sheet = excel.Typed(MKDData);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown14", "Unknown9", "ZoneName", "CurrencyItem[0]", "CurrencyName[0]", "Unknown11", "CurrencyItem[1]", "CurrencyName[1]", "Unknown12", "CipherItem", "CipherName", "Quest", "Unknown10", "Unknown8", "Unknown13" };

/// Links to `Addon`.
pub fn zoneName(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(u32, 0));
}

pub const currency_item_len = 2;
/// Links to `Item`.
pub fn currencyItem(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

/// Links to `Item`.
pub fn cipherItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 12));
}

pub fn unknown10(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub const currency_name_len = 2;
/// Links to `Addon`.
pub fn currencyName(self: @This(), n0: usize) excel.Link(sheets.Addon) {
    return .of(self.row.at(u32, offsets_2[n0]));
}

/// Links to `Addon`.
pub fn cipherName(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(i32, 28));
}

/// Minimum Knowledge Level?
pub fn unknown8(self: @This()) i32 {
    return self.row.at(i32, 32);
}

pub fn unknown11(self: @This()) i32 {
    return self.row.at(i32, 36);
}

pub fn unknown12(self: @This()) i32 {
    return self.row.at(i32, 40);
}

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(i32, 44));
}

pub fn unknown13(self: @This()) i32 {
    return self.row.at(i32, 48);
}

pub fn unknown14(self: @This()) u8 {
    return self.row.at(u8, 52);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 53);
}

const offsets_1 = [2]u16{ 4, 8 };
const offsets_2 = [2]u16{ 20, 24 };
