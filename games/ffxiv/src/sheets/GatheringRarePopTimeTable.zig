//! `GatheringRarePopTimeTable`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringRarePopTimeTable = @This();

pub const sheet_name = "GatheringRarePopTimeTable";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x865de322;
pub const Sheet = excel.Typed(GatheringRarePopTimeTable);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "StartTime[0]", "Duration[0]", "StartTime[1]", "Duration[1]", "StartTime[2]", "Duration[2]" };

pub const start_time_len = 3;
pub fn startTime(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_1[n0]);
}

pub const duration_len = 3;
pub fn duration(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

const offsets_1 = [3]u16{ 0, 2, 4 };
const offsets_2 = [3]u16{ 6, 8, 10 };
