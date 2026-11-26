//! `PlantPotFlowerSeed`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PlantPotFlowerSeed = @This();

pub const sheet_name = "PlantPotFlowerSeed";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x84d0ceef;
pub const Sheet = excel.Typed(PlantPotFlowerSeed);

row: excel.Row,

pub const seed_icon_len = 9;
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn seedIcon(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

const offsets_1 = [9]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32 };
