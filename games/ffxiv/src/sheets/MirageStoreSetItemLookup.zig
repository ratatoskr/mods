//! `MirageStoreSetItemLookup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MirageStoreSetItemLookup = @This();

pub const sheet_name = "MirageStoreSetItemLookup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6be0e840;
pub const Sheet = excel.Typed(MirageStoreSetItemLookup);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item[0]", "Item[1]", "Item[2]", "Item[3]", "Item[4]" };

pub const item_len = 5;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

const offsets_1 = [5]u16{ 0, 4, 8, 12, 16 };
