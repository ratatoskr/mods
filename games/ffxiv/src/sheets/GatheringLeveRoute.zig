//! `GatheringLeveRoute`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringLeveRoute = @This();

pub const sheet_name = "GatheringLeveRoute";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf20ec1e1;
pub const Sheet = excel.Typed(GatheringLeveRoute);

row: excel.Row,

pub const gathering_point_len = 12;
/// Links to `GatheringPoint`.
pub fn gatheringPoint(self: @This(), n0: usize) excel.Link(sheets.GatheringPoint) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub const pop_range_len = 12;
/// Links to `Level`.
pub fn popRange(self: @This(), n0: usize) excel.Link(sheets.Level) {
    return .of(self.row.at(i32, offsets_2[n0]));
}

const offsets_1 = [12]u16{ 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44 };
const offsets_2 = [12]u16{ 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92 };
