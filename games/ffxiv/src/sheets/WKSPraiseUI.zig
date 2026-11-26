//! `WKSPraiseUI`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSPraiseUI = @This();

pub const sheet_name = "WKSPraiseUI";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0c8db36c;
pub const Sheet = excel.Typed(WKSPraiseUI);

row: excel.Row,

pub fn message(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn backdrop(self: @This()) i32 {
    return self.row.at(i32, 4);
}
