//! `AOZContentBriefingObject`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AOZContentBriefingObject = @This();

pub const sheet_name = "AOZContentBriefingObject";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x5edc18ea;
pub const Sheet = excel.Typed(AOZContentBriefingObject);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Icon", "Unknown0" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}
