//! `WKSMissionSupplyItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionSupplyItem = @This();

pub const sheet_name = "WKSMissionSupplyItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x865de322;
pub const Sheet = excel.Typed(WKSMissionSupplyItem);

row: excel.Row,

pub const item_len = 3;
/// Links to `WKSItemInfo`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.WKSItemInfo) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub const item_count_len = 3;
pub fn itemCount(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

const offsets_1 = [3]u16{ 0, 2, 4 };
const offsets_2 = [3]u16{ 6, 8, 10 };
