//! `FCRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FCRank = @This();

pub const sheet_name = "FCRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0105b558;
pub const Sheet = excel.Typed(FCRank);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "NextPoint", "CurrentPoint", "Rights", "Unknown0", "Unknown1", "FCActionActiveNum", "FCActionStockNum", "FCChestCompartments" };

pub fn nextPoint(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn currentPoint(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn rights(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn fcActionActiveNum(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn fcActionStockNum(self: @This()) u8 {
    return self.row.at(u8, 15);
}

pub fn fcChestCompartments(self: @This()) u8 {
    return self.row.at(u8, 16);
}
