//! `MainCommandCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MainCommandCategory = @This();

pub const sheet_name = "MainCommandCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0c8db36c;
pub const Sheet = excel.Typed(MainCommandCategory);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 4);
}
