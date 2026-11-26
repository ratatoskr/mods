//! `MJIHudMode`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIHudMode = @This();

pub const sheet_name = "MJIHudMode";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb786ca47;
pub const Sheet = excel.Typed(MJIHudMode);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn title(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 12);
}
