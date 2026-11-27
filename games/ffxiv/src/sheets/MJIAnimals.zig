//! `MJIAnimals`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIAnimals = @This();

pub const sheet_name = "MJIAnimals";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xeae74967;
pub const Sheet = excel.Typed(MJIAnimals);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "BNpcBase", "Size", "Unknown0", "Unknown1", "Reward[0]", "Reward[1]", "Icon" };

/// Links to `BNpcBase`.
pub fn bNpcBase(self: @This()) excel.Link(sheets.BNpcBase) {
    return .of(self.row.at(u32, 0));
}

pub const reward_len = 2;
/// Links to `Item`.
pub fn reward(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn size(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 17);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 18);
}

const offsets_1 = [2]u16{ 4, 8 };
