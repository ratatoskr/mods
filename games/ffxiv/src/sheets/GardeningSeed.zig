//! `GardeningSeed`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GardeningSeed = @This();

pub const sheet_name = "GardeningSeed";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa8a6cb9c;
pub const Sheet = excel.Typed(GardeningSeed);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn modelID(self: @This()) u16 {
    return self.row.at(u16, 8);
}

/// Links to `PlantPotFlowerSeed`.
pub fn plantPotFlowerSeed(self: @This()) excel.Link(sheets.PlantPotFlowerSeed) {
    return .of(self.row.at(u8, 10));
}

pub fn se(self: @This()) bool {
    return self.row.bitAt(11, 0);
}

pub fn isPlantPotFlowerSeed(self: @This()) bool {
    return self.row.bitAt(11, 1);
}
