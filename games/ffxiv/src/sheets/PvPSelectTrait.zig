//! `PvPSelectTrait`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPSelectTrait = @This();

pub const sheet_name = "PvPSelectTrait";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbddf8130;
pub const Sheet = excel.Typed(PvPSelectTrait);

row: excel.Row,

pub fn effect(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn value(self: @This()) i16 {
    return self.row.at(i16, 8);
}
