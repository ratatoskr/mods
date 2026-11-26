//! `ContentsNoteLevel`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentsNoteLevel = @This();

pub const sheet_name = "ContentsNoteLevel";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdd3ff48d;
pub const Sheet = excel.Typed(ContentsNoteLevel);

row: excel.Row,

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 0);
}
