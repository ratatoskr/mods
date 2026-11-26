//! `AirshipExplorationLevel`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AirshipExplorationLevel = @This();

pub const sheet_name = "AirshipExplorationLevel";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x382abf74;
pub const Sheet = excel.Typed(AirshipExplorationLevel);

row: excel.Row,

pub fn expToNext(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn capacity(self: @This()) u16 {
    return self.row.at(u16, 4);
}
