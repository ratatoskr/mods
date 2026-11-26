//! `MateriaJoinRateGatherCraft`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MateriaJoinRateGatherCraft = @This();

pub const sheet_name = "MateriaJoinRateGatherCraft";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xab31b42e;
pub const Sheet = excel.Typed(MateriaJoinRateGatherCraft);

row: excel.Row,

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
