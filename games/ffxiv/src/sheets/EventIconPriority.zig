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

pub const icon_len = 29;
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

const offsets_1 = [29]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112 };
