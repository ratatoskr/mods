//! `DescriptionPage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DescriptionPage = @This();

pub const sheet_name = "DescriptionPage";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xda11a692;
pub const Sheet = excel.Typed(DescriptionPage);

row: excel.Row,

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub const image_len = 11;
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

pub const text_len = 11;
/// Links to `DescriptionString`.
pub fn text(self: @This(), n0: usize) excel.Link(sheets.DescriptionString) {
    return .of(self.row.at(u16, offsets_2[n0]));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 74);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 76);
}

const offsets_1 = [11]u16{ 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48 };
const offsets_2 = [11]u16{ 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72 };
