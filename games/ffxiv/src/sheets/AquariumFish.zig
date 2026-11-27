//! `AquariumFish`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AquariumFish = @This();

pub const sheet_name = "AquariumFish";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9b5e32ba;
pub const Sheet = excel.Typed(AquariumFish);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "AquariumWater", "Size", "Item", "Unknown0" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `AquariumWater`.
pub fn aquariumWater(self: @This()) excel.Link(sheets.AquariumWater) {
    return .of(self.row.at(u8, 6));
}

pub fn size(self: @This()) u8 {
    return self.row.at(u8, 7);
}
