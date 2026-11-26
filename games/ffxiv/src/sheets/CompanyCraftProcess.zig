//! `CompanyCraftProcess`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanyCraftProcess = @This();

pub const sheet_name = "CompanyCraftProcess";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3135b48e;
pub const Sheet = excel.Typed(CompanyCraftProcess);

row: excel.Row,

pub const supply_item_len = 12;
/// Links to `CompanyCraftSupplyItem`.
pub fn supplyItem(self: @This(), n0: usize) excel.Link(sheets.CompanyCraftSupplyItem) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub const set_quantity_len = 12;
pub fn setQuantity(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

pub const sets_required_len = 12;
pub fn setsRequired(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_3[n0]);
}

const offsets_1 = [12]u16{ 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22 };
const offsets_2 = [12]u16{ 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46 };
const offsets_3 = [12]u16{ 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70 };
