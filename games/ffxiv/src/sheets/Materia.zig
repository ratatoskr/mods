//! `Materia`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Materia = @This();

pub const sheet_name = "Materia";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x690ce1c4;
pub const Sheet = excel.Typed(Materia);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item[0]", "Item[1]", "Item[2]", "Item[3]", "Item[4]", "Item[5]", "Item[6]", "Item[7]", "Item[8]", "Item[9]", "Item[10]", "Item[11]", "Item[12]", "Item[13]", "Item[14]", "Item[15]", "BaseParam", "Value[0]", "Value[1]", "Value[2]", "Value[3]", "Value[4]", "Value[5]", "Value[6]", "Value[7]", "Value[8]", "Value[9]", "Value[10]", "Value[11]", "Value[12]", "Value[13]", "Value[14]", "Value[15]" };

pub const item_len = 16;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub const value_len = 16;
pub fn value(self: @This(), n0: usize) i16 {
    return self.row.at(i16, offsets_2[n0]);
}

/// Links to `BaseParam`.
pub fn baseParam(self: @This()) excel.Link(sheets.BaseParam) {
    return .of(self.row.at(u8, 96));
}

const offsets_1 = [16]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60 };
const offsets_2 = [16]u16{ 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94 };
