//! `LeveRewardItemGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LeveRewardItemGroup = @This();

pub const sheet_name = "LeveRewardItemGroup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf065e622;
pub const Sheet = excel.Typed(LeveRewardItemGroup);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item[0]", "Count[0]", "IsHQ[0]", "Item[1]", "Count[1]", "IsHQ[1]", "Item[2]", "Count[2]", "IsHQ[2]", "Item[3]", "Count[3]", "IsHQ[3]", "Item[4]", "Count[4]", "IsHQ[4]", "Item[5]", "Count[5]", "IsHQ[5]", "Item[6]", "Count[6]", "IsHQ[6]", "Item[7]", "Count[7]", "IsHQ[7]", "Item[8]", "Count[8]", "IsHQ[8]" };

pub const item_len = 9;
/// Links to `Item`.
pub fn item(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub const count_len = 9;
pub fn count(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

pub const is_hq_len = 9;
pub fn isHQ(self: @This(), n0: usize) bool {
    return self.row.at(u8, offsets_3[n0]) != 0;
}

const offsets_1 = [9]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32 };
const offsets_2 = [9]u16{ 36, 37, 38, 39, 40, 41, 42, 43, 44 };
const offsets_3 = [9]u16{ 45, 46, 47, 48, 49, 50, 51, 52, 53 };
