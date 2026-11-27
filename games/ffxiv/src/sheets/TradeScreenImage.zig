//! `TradeScreenImage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TradeScreenImage = @This();

pub const sheet_name = "TradeScreenImage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa0995e80;
pub const Sheet = excel.Typed(TradeScreenImage);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Items[0]", "Items[1]", "ItemIcons[0]", "ItemIcons[1]", "ItemValues[0]", "ItemValues[1]", "BannerType" };

pub const items_len = 2;
/// Links to `EventItem`.
pub fn items(self: @This(), n0: usize) excel.Link(sheets.EventItem) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub const item_icons_len = 2;
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn itemIcons(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_2[n0]);
}

pub const item_values_len = 2;
pub fn itemValues(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_3[n0]);
}

/// 1 = Icon 180096 ("Excellent Trade!"), 2 = Icon 180097 ("Feat Accomplished!")
pub fn bannerType(self: @This()) u8 {
    return self.row.at(u8, 24);
}

const offsets_1 = [2]u16{ 0, 4 };
const offsets_2 = [2]u16{ 8, 12 };
const offsets_3 = [2]u16{ 16, 20 };
