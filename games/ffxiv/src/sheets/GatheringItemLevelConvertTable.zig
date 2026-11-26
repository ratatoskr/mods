//! `GatheringItemLevelConvertTable`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringItemLevelConvertTable = @This();

pub const sheet_name = "GatheringItemLevelConvertTable";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xde74b4c4;
pub const Sheet = excel.Typed(GatheringItemLevelConvertTable);

row: excel.Row,

pub fn gatheringItemLevel(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn stars(self: @This()) u8 {
    return self.row.at(u8, 1);
}
