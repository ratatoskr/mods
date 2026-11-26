//! `Stain`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Stain = @This();

pub const sheet_name = "Stain";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x346c5926;
pub const Sheet = excel.Typed(Stain);

row: excel.Row,

pub fn inlineName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An RGB color, 0xRRGGBB.
pub fn color(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub const item_len = 2;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn shade(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn subOrder(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn isMetallic(self: @This()) bool {
    return self.row.bitAt(22, 0);
}

pub fn isHousingApplicable(self: @This()) bool {
    return self.row.bitAt(22, 1);
}

const offsets_1 = [2]u16{ 12, 16 };
