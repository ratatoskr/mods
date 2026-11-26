//! `Town`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Town = @This();

pub const sheet_name = "Town";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x993d983d;
pub const Sheet = excel.Typed(Town);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 4);
}
