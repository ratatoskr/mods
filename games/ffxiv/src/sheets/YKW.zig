//! `YKW`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const YKW = @This();

pub const sheet_name = "YKW";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x12e24636;
pub const Sheet = excel.Typed(YKW);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Companion", "Item", "Location[0]", "Location[1]", "Location[2]", "Location[3]", "Location[4]", "Location[5]", "Transient" };

pub fn transient(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Companion`.
pub fn companion(self: @This()) excel.Link(sheets.Companion) {
    return .of(self.row.at(u16, 8));
}

pub const location_len = 6;
/// Links to `TerritoryType`.
pub fn location(self: @This(), n0: usize) excel.Link(sheets.TerritoryType) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [6]u16{ 10, 12, 14, 16, 18, 20 };
