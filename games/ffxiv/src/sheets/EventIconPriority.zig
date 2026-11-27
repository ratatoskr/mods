//! `EventIconPriority`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventIconPriority = @This();

pub const sheet_name = "EventIconPriority";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3bcf5bd0;
pub const Sheet = excel.Typed(EventIconPriority);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Icon[0]", "Icon[1]", "Icon[2]", "Icon[3]", "Icon[4]", "Icon[5]", "Icon[6]", "Icon[7]", "Icon[8]", "Icon[9]", "Icon[10]", "Icon[11]", "Icon[12]", "Icon[13]", "Icon[14]", "Icon[15]", "Icon[16]", "Icon[17]", "Icon[18]", "Icon[19]", "Icon[20]", "Icon[21]", "Icon[22]", "Icon[23]", "Icon[24]", "Icon[25]", "Icon[26]", "Icon[27]", "Icon[28]" };

pub const icon_len = 29;
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

const offsets_1 = [29]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112 };
