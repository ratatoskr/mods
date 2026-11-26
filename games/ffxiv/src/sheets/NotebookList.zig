//! `NotebookList`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const NotebookList = @This();

pub const sheet_name = "NotebookList";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(NotebookList);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}
