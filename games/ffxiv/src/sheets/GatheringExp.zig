//! `GatheringExp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringExp = @This();

pub const sheet_name = "GatheringExp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(GatheringExp);

row: excel.Row,

pub fn exp(self: @This()) i32 {
    return self.row.at(i32, 0);
}
