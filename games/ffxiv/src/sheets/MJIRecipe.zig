//! `MJIRecipe`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `KeyItem`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIRecipe = @This();

pub const sheet_name = "MJIRecipe";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcfeffbad;
pub const Sheet = excel.Typed(MJIRecipe);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LogMessage", "KeyItem", "ItemPouch", "Yield", "Material[0]", "Amount[0]", "Material[1]", "Amount[1]", "Material[2]", "Amount[2]", "Material[3]", "Amount[3]", "Material[4]", "Amount[4]", "Order" };

/// Links to `LogMessage`.
pub fn logMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 0));
}

/// Links to `MJIKeyItem`.
pub fn keyItem(self: @This()) excel.Link(sheets.MJIKeyItem) {
    return .of(self.row.at(u8, 4));
}

/// Links to `MJIItemPouch`.
pub fn itemPouch(self: @This()) excel.Link(sheets.MJIItemPouch) {
    return .of(self.row.at(u8, 5));
}

pub fn yield(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub const material_len = 5;
/// Links to `MJIRecipeMaterial`.
pub fn material(self: @This(), n0: usize) excel.Link(sheets.MJIRecipeMaterial) {
    return .of(self.row.at(u8, offsets_1[n0]));
}

pub const amount_len = 5;
pub fn amount(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 17);
}

const offsets_1 = [5]u16{ 7, 8, 9, 10, 11 };
const offsets_2 = [5]u16{ 12, 13, 14, 15, 16 };
