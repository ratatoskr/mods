//! `PvPRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPRank = @This();

pub const sheet_name = "PvPRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(PvPRank);

row: excel.Row,

pub fn expRequired(self: @This()) u32 {
    return self.row.at(u32, 0);
}
