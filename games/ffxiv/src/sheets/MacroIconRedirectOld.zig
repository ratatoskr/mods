//! `MacroIconRedirectOld`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MacroIconRedirectOld = @This();

pub const sheet_name = "MacroIconRedirectOld";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5c9aa6b3;
pub const Sheet = excel.Typed(MacroIconRedirectOld);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "IconOld", "IconNew" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconOld(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconNew(self: @This()) i32 {
    return self.row.at(i32, 4);
}
