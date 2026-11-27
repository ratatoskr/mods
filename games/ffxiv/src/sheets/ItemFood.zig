//! `ItemFood`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemFood = @This();

pub const sheet_name = "ItemFood";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe09a474d;
pub const Sheet = excel.Typed(ItemFood);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EXPBonusPercent", "BaseParam[0]", "IsRelative[0]", "Value[0]", "Max[0]", "ValueHQ[0]", "MaxHQ[0]", "BaseParam[1]", "IsRelative[1]", "Value[1]", "Max[1]", "ValueHQ[1]", "MaxHQ[1]", "BaseParam[2]", "IsRelative[2]", "Value[2]", "Max[2]", "ValueHQ[2]", "MaxHQ[2]" };

pub const max_len = 3;
pub fn max(self: @This(), n0: usize) i16 {
    return self.row.at(i16, offsets_1[n0]);
}

pub const max_hq_len = 3;
pub fn maxHQ(self: @This(), n0: usize) i16 {
    return self.row.at(i16, offsets_2[n0]);
}

pub fn expBonusPercent(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub const base_param_len = 3;
/// Links to `BaseParam`.
pub fn baseParam(self: @This(), n0: usize) excel.Link(sheets.BaseParam) {
    return .of(self.row.at(u8, offsets_3[n0]));
}

pub const value_len = 3;
pub fn value(self: @This(), n0: usize) i8 {
    return self.row.at(i8, offsets_4[n0]);
}

pub const value_hq_len = 3;
pub fn valueHQ(self: @This(), n0: usize) i8 {
    return self.row.at(i8, offsets_5[n0]);
}

pub const is_relative_len = 3;
pub fn isRelative(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_6[n0]) != 0;
}

const offsets_1 = [3]u16{ 0, 2, 4 };
const offsets_2 = [3]u16{ 6, 8, 10 };
const offsets_3 = [3]u16{ 13, 14, 15 };
const offsets_4 = [3]u16{ 16, 17, 18 };
const offsets_5 = [3]u16{ 19, 20, 21 };
const offsets_6 = [3]u16{ 22, 23, 24 };
