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

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SupplyItem[0]", "SetQuantity[0]", "SetsRequired[0]", "SupplyItem[1]", "SetQuantity[1]", "SetsRequired[1]", "SupplyItem[2]", "SetQuantity[2]", "SetsRequired[2]", "SupplyItem[3]", "SetQuantity[3]", "SetsRequired[3]", "SupplyItem[4]", "SetQuantity[4]", "SetsRequired[4]", "SupplyItem[5]", "SetQuantity[5]", "SetsRequired[5]", "SupplyItem[6]", "SetQuantity[6]", "SetsRequired[6]", "SupplyItem[7]", "SetQuantity[7]", "SetsRequired[7]", "SupplyItem[8]", "SetQuantity[8]", "SetsRequired[8]", "SupplyItem[9]", "SetQuantity[9]", "SetsRequired[9]", "SupplyItem[10]", "SetQuantity[10]", "SetsRequired[10]", "SupplyItem[11]", "SetQuantity[11]", "SetsRequired[11]" };

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
