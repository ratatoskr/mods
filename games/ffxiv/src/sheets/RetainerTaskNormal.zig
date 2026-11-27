//! `RetainerTaskNormal`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RetainerTaskNormal = @This();

pub const sheet_name = "RetainerTaskNormal";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x644a4310;
pub const Sheet = excel.Typed(RetainerTaskNormal);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "Quantity[0]", "Quantity[1]", "Quantity[2]", "Quantity[3]", "Quantity[4]", "GatheringLog", "FishingLog" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

/// Links to `GatheringItem`.
pub fn gatheringLog(self: @This()) excel.Link(sheets.GatheringItem) {
    return .of(self.row.at(i16, 4));
}

/// Links to `SpearfishingItem` or `FishParameter`, whichever has the row.
pub fn fishingLog(self: @This()) i16 {
    return self.row.at(i16, 6);
}

pub const quantity_len = 5;
pub fn quantity(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_1[n0]);
}

const offsets_1 = [5]u16{ 8, 9, 10, 11, 12 };
