//! `MJIGatheringItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIGatheringItem = @This();

pub const sheet_name = "MJIGatheringItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0dd2ae8d;
pub const Sheet = excel.Typed(MJIGatheringItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "Sort", "Unknown0", "X", "Y", "Radius", "Unknown1" };

pub fn radius(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn x(self: @This()) i16 {
    return self.row.at(i16, 2);
}

pub fn y(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 7);
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

pub fn sort(self: @This()) u8 {
    return self.row.at(u8, 12);
}
