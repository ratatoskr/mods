//! `GathererReductionReward`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GathererReductionReward = @This();

pub const sheet_name = "GathererReductionReward";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x351cf6e2;
pub const Sheet = excel.Typed(GathererReductionReward);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(2, 0);
}
