//! `CraftLeve`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Leve`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CraftLeve = @This();

pub const sheet_name = "CraftLeve";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x51a3acc3;
pub const Sheet = excel.Typed(CraftLeve);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Leve", "CraftLeveTalk", "Repeats", "Item[0]", "ItemCount[0]", "Item[1]", "ItemCount[1]", "Item[2]", "ItemCount[2]", "Item[3]", "ItemCount[3]" };

/// Links to `Leve`.
pub fn leve(self: @This()) excel.Link(sheets.Leve) {
    return .of(self.row.at(i32, 0));
}

/// Links to `CraftLeveTalk`.
pub fn craftLeveTalk(self: @This()) excel.Link(sheets.CraftLeveTalk) {
    return .of(self.row.at(i32, 4));
}

pub const item_len = 4;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub const item_count_len = 4;
pub fn itemCount(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

pub fn repeats(self: @This()) u8 {
    return self.row.at(u8, 32);
}

const offsets_1 = [4]u16{ 8, 12, 16, 20 };
const offsets_2 = [4]u16{ 24, 26, 28, 30 };
