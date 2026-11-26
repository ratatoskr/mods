//! `MJICraftworksRankRatio`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJICraftworksRankRatio = @This();

pub const sheet_name = "MJICraftworksRankRatio";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(MJICraftworksRankRatio);

row: excel.Row,

pub fn ratio(self: @This()) u16 {
    return self.row.at(u16, 0);
}
