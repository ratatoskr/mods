//! `MateriaJoinRate`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MateriaJoinRate = @This();

pub const sheet_name = "MateriaJoinRate";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xab31b42e;
pub const Sheet = excel.Typed(MateriaJoinRate);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "NQOvermeldPercentSlot[0]", "NQOvermeldPercentSlot[1]", "NQOvermeldPercentSlot[2]", "NQOvermeldPercentSlot[3]", "HQOvermeldPercentSlot[0]", "HQOvermeldPercentSlot[1]", "HQOvermeldPercentSlot[2]", "HQOvermeldPercentSlot[3]" };

pub const nq_overmeld_percent_slot_len = 4;
pub fn nqOvermeldPercentSlot(self: @This(), n0: usize) f32 {
    return self.row.at(f32, offsets_1[n0]);
}

pub const hq_overmeld_percent_slot_len = 4;
pub fn hqOvermeldPercentSlot(self: @This(), n0: usize) f32 {
    return self.row.at(f32, offsets_2[n0]);
}

const offsets_1 = [4]u16{ 0, 4, 8, 12 };
const offsets_2 = [4]u16{ 16, 20, 24, 28 };
