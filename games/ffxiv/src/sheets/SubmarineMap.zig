//! `SubmarineMap`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SubmarineMap = @This();

pub const sheet_name = "SubmarineMap";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x98fff20a;
pub const Sheet = excel.Typed(SubmarineMap);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) u32 {
    return self.row.at(u32, 4);
}
