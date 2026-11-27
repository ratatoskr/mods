//! `DynamicEventType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DynamicEventType = @This();

pub const sheet_name = "DynamicEventType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(DynamicEventType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "IconObjective0", "IconObjective1" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconObjective0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconObjective1(self: @This()) u32 {
    return self.row.at(u32, 4);
}
