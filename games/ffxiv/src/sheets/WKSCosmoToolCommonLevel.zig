//! `WKSCosmoToolCommonLevel`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSCosmoToolCommonLevel = @This();

pub const sheet_name = "WKSCosmoToolCommonLevel";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd4cb81c;
pub const Sheet = excel.Typed(WKSCosmoToolCommonLevel);

row: excel.Row,

pub fn isCommon(self: @This()) bool {
    return self.row.bitAt(0, 0);
}
