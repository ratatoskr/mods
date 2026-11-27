//! `RetainerTaskParameter`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RetainerTaskParameter = @This();

pub const sheet_name = "RetainerTaskParameter";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4723e1b0;
pub const Sheet = excel.Typed(RetainerTaskParameter);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ItemLevelDoW[0]", "ItemLevelDoW[1]", "ItemLevelDoW[2]", "ItemLevelDoW[3]", "PerceptionDoL[0]", "PerceptionDoL[1]", "PerceptionDoL[2]", "PerceptionDoL[3]", "PerceptionFSH[0]", "PerceptionFSH[1]", "PerceptionFSH[2]", "PerceptionFSH[3]" };

pub const item_level_do_w_len = 4;
pub fn itemLevelDoW(self: @This(), n0: usize) i16 {
    return self.row.at(i16, offsets_1[n0]);
}

pub const perception_do_l_len = 4;
pub fn perceptionDoL(self: @This(), n0: usize) i16 {
    return self.row.at(i16, offsets_2[n0]);
}

pub const perception_fsh_len = 4;
pub fn perceptionFSH(self: @This(), n0: usize) i16 {
    return self.row.at(i16, offsets_3[n0]);
}

const offsets_1 = [4]u16{ 0, 2, 4, 6 };
const offsets_2 = [4]u16{ 8, 10, 12, 14 };
const offsets_3 = [4]u16{ 16, 18, 20, 22 };
