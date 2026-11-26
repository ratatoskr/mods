//! `EurekaGrowData`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `BaseResistance`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EurekaGrowData = @This();

pub const sheet_name = "EurekaGrowData";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(EurekaGrowData);

row: excel.Row,

pub fn baseResistance(self: @This()) u16 {
    return self.row.at(u16, 0);
}
