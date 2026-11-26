//! `MKDGrowDataSJob`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MKDGrowDataSJob = @This();

pub const sheet_name = "MKDGrowDataSJob";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(MKDGrowDataSJob);

row: excel.Row,

pub fn expToNext(self: @This()) u32 {
    return self.row.at(u32, 0);
}
