//! `FateMode`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FateMode = @This();

pub const sheet_name = "FateMode";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6be0e840;
pub const Sheet = excel.Typed(FateMode);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LogMessage", "MotivationIcon", "MotivationMapMarker", "ObjectiveIcon", "ObjectiveMapMarker" };

/// Links to `LogMessage`.
pub fn logMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 0));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn motivationIcon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn motivationMapMarker(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn objectiveIcon(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn objectiveMapMarker(self: @This()) u32 {
    return self.row.at(u32, 16);
}
