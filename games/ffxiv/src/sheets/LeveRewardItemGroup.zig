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
