//! `ValentionSweetsRecipe`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ValentionSweetsRecipe = @This();

pub const sheet_name = "ValentionSweetsRecipe";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x09fdff4a;
pub const Sheet = excel.Typed(ValentionSweetsRecipe);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Material[0]", "Quantity[0]", "Material[1]", "Quantity[1]", "Material[2]", "Quantity[2]", "Material[3]", "Quantity[3]", "Material[4]", "Quantity[4]", "Material[5]", "Quantity[5]", "Material[6]", "Quantity[6]", "Material[7]", "Quantity[7]" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const material_len = 8;
/// Links to `ValentionSweetsMaterial`.
pub fn material(self: @This(), n0: usize) excel.Link(sheets.ValentionSweetsMaterial) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

pub const quantity_len = 8;
pub fn quantity(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

const offsets_1 = [8]u16{ 4, 5, 6, 7, 8, 9, 10, 11 };
const offsets_2 = [8]u16{ 12, 13, 14, 15, 16, 17, 18, 19 };
