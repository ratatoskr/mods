//! `MJICraftworksObject`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJICraftworksObject = @This();

pub const sheet_name = "MJICraftworksObject";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xca934bcc;
pub const Sheet = excel.Typed(MJICraftworksObject);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u16, 0));
}

pub const theme_len = 2;
/// Links to `MJICraftworksObjectTheme`.
pub fn theme(self: @This(), n0: usize) excel.Link(sheets.MJICraftworksObjectTheme) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub const material_len = 4;
/// Links to `MJIItemPouch`.
pub fn material(self: @This(), n0: usize) excel.Link(sheets.MJIItemPouch) {
    return .of(self.row.at(u16, offsets_2[n0]));
}

pub const amount_len = 4;
pub fn amount(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_3[n0]);
}

pub fn levelReq(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn craftingTime(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn value(self: @This()) u16 {
    return self.row.at(u16, 28);
}

const offsets_1 = [2]u16{ 2, 4 };
const offsets_2 = [4]u16{ 8, 10, 12, 14 };
const offsets_3 = [4]u16{ 16, 18, 20, 22 };
