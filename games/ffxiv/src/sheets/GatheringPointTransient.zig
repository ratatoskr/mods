//! `GatheringPointTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringPointTransient = @This();

pub const sheet_name = "GatheringPointTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7164626b;
pub const Sheet = excel.Typed(GatheringPointTransient);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EphemeralStartTime", "EphemeralEndTime", "GatheringRarePopTimeTable" };

/// Links to `GatheringRarePopTimeTable`.
pub fn gatheringRarePopTimeTable(self: @This()) excel.Link(sheets.GatheringRarePopTimeTable) {
    return .of(self.row.at(i32, 0));
}

pub fn ephemeralStartTime(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn ephemeralEndTime(self: @This()) u16 {
    return self.row.at(u16, 6);
}
