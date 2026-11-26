//! `OrnamentCustomizeGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OrnamentCustomizeGroup = @This();

pub const sheet_name = "OrnamentCustomizeGroup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8029343c;
pub const Sheet = excel.Typed(OrnamentCustomizeGroup);

row: excel.Row,

pub const customize_len = 21;
/// Links to `OrnamentCustomize`.
pub fn customize(self: @This(), n0: usize) excel.Link(sheets.OrnamentCustomize) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub fn attachmentPoint(self: @This()) u8 {
    return self.row.at(u8, 42);
}

const offsets_1 = [21]u16{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40 };
