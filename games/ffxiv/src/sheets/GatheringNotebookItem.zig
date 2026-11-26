//! `GatheringNotebookItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringNotebookItem = @This();

pub const sheet_name = "GatheringNotebookItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(GatheringNotebookItem);

row: excel.Row,

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}
