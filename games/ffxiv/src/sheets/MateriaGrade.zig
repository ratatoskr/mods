//! `MateriaGrade`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MateriaGrade = @This();

pub const sheet_name = "MateriaGrade";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc9ef8fad;
pub const Sheet = excel.Typed(MateriaGrade);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ReturnRate", "MeldFee", "OvermeldNQPercent[0]", "OvermeldNQPercent[1]", "OvermeldNQPercent[2]", "OvermeldNQPercent[3]", "OvermeldHQPercent[0]", "OvermeldHQPercent[1]", "OvermeldHQPercent[2]", "OvermeldHQPercent[3]" };

pub fn meldFee(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn returnRate(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub const overmeld_nq_percent_len = 4;
pub fn overmeldNQPercent(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_1[n0]);
}

pub const overmeld_hq_percent_len = 4;
pub fn overmeldHQPercent(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

const offsets_1 = [4]u16{ 3, 4, 5, 6 };
const offsets_2 = [4]u16{ 7, 8, 9, 10 };
