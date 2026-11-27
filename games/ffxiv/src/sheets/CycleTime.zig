//! `CycleTime`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CycleTime = @This();

pub const sheet_name = "CycleTime";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(CycleTime);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "FirstCycle", "Cycle" };

pub fn firstCycle(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn cycle(self: @This()) u32 {
    return self.row.at(u32, 4);
}
