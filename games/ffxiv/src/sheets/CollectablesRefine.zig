//! `CollectablesRefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CollectablesRefine = @This();

pub const sheet_name = "CollectablesRefine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdc23efe7;
pub const Sheet = excel.Typed(CollectablesRefine);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "CollectabilityLow", "CollectabilityMid", "CollectabilityHigh" };

pub fn collectabilityLow(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn collectabilityMid(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn collectabilityHigh(self: @This()) u16 {
    return self.row.at(u16, 4);
}
