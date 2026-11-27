//! `ExportedGatheringPoint`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ExportedGatheringPoint = @This();

pub const sheet_name = "ExportedGatheringPoint";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda46099c;
pub const Sheet = excel.Typed(ExportedGatheringPoint);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "X", "Y", "GatheringType", "GatheringPointType", "Radius" };

pub fn x(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn y(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn radius(self: @This()) u16 {
    return self.row.at(u16, 8);
}

/// Links to `GatheringType`.
pub fn gatheringType(self: @This()) excel.Link(sheets.GatheringType) {
    return .of(self.row.at(u8, 10));
}

pub fn gatheringPointType(self: @This()) u8 {
    return self.row.at(u8, 11);
}
