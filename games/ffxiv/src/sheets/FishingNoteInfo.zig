//! `FishingNoteInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FishingNoteInfo = @This();

pub const sheet_name = "FishingNoteInfo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbe43ccf1;
pub const Sheet = excel.Typed(FishingNoteInfo);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Size", "AquariumWater", "WeatherRestriction", "TimeRestriction", "SpecialConditions", "IsCollectable", "Item" };

/// Links to `EventItem` or `Item`, whichever has the row.
pub fn item(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn size(self: @This()) u8 {
    return self.row.at(u8, 4);
}

/// Links to `AquariumWater`.
pub fn aquariumWater(self: @This()) excel.Link(sheets.AquariumWater) {
    return .of(self.row.at(u8, 5));
}

pub fn weatherRestriction(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn timeRestriction(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn specialConditions(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn isCollectable(self: @This()) u8 {
    return self.row.at(u8, 9);
}
