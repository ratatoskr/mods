//! `InstanceContentRewardItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InstanceContentRewardItem = @This();

pub const sheet_name = "InstanceContentRewardItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x79c1d547;
pub const Sheet = excel.Typed(InstanceContentRewardItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1" };

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 0);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 1);
}
