//! `SpearfishingSilhouette`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SpearfishingSilhouette = @This();

pub const sheet_name = "SpearfishingSilhouette";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(SpearfishingSilhouette);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}
