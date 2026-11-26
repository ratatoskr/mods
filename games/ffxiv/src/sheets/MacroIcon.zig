//! `MacroIcon`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Icon`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MacroIcon = @This();

pub const sheet_name = "MacroIcon";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf8ab135e;
pub const Sheet = excel.Typed(MacroIcon);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}
