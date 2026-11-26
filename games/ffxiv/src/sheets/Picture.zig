//! `Picture`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Image`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Picture = @This();

pub const sheet_name = "Picture";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfaedad07;
pub const Sheet = excel.Typed(Picture);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn image(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn signature(self: @This()) i32 {
    return self.row.at(i32, 4);
}
