//! `GatheringPointBase`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringPointBase = @This();

pub const sheet_name = "GatheringPointBase";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb34093c0;
pub const Sheet = excel.Typed(GatheringPointBase);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "GatheringType", "GatheringLevel", "Item[0]", "Item[1]", "Item[2]", "Item[3]", "Item[4]", "Item[5]", "Item[6]", "Item[7]" };

/// Links to `GatheringType`.
pub fn gatheringType(self: @This()) excel.Link(sheets.GatheringType) {
    return .of(self.row.at(i32, 0));
}

pub const item_len = 8;
/// Links to `GatheringItem` or `SpearfishingItem`, whichever has the row.
pub fn item(self: @This(), n0: usize) i32 {
    return self.row.at(i32, offsets_1[n0]);
}

pub fn gatheringLevel(self: @This()) u8 {
    return self.row.at(u8, 36);
}

const offsets_1 = [8]u16{ 4, 8, 12, 16, 20, 24, 28, 32 };
