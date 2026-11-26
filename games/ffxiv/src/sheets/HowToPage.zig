//! `HowToPage`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Image`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HowToPage = @This();

pub const sheet_name = "HowToPage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x006e1eac;
pub const Sheet = excel.Typed(HowToPage);

row: excel.Row,

pub const text_len = 3;
pub fn text(self: @This(), n0: usize) []const u8 {
    return self.row.stringAt(offsets_1[n0]);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn iconType(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn textType(self: @This()) u8 {
    return self.row.at(u8, 18);
}

const offsets_1 = [3]u16{ 0, 4, 8 };
