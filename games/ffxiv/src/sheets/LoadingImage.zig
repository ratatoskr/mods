//! `LoadingImage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LoadingImage = @This();

pub const sheet_name = "LoadingImage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdebb20e3;
pub const Sheet = excel.Typed(LoadingImage);

row: excel.Row,

pub fn fileName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}
