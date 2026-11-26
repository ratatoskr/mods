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
