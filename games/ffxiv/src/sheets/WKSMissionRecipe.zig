//! `WKSMissionRecipe`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionRecipe = @This();

pub const sheet_name = "WKSMissionRecipe";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb1d6de9b;
pub const Sheet = excel.Typed(WKSMissionRecipe);

row: excel.Row,

pub const recipe_len = 5;
/// Links to `Recipe`.
pub fn recipe(self: @This(), n0: usize) excel.Link(sheets.Recipe) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(20, 0);
}

const offsets_1 = [5]u16{ 0, 4, 8, 12, 16 };
