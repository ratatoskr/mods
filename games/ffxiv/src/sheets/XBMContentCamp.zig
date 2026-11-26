//! `XBMContentCamp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const XBMContentCamp = @This();

pub const sheet_name = "XBMContentCamp";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(XBMContentCamp);

row: excel.Row,

/// Based on how they appear from bottom to top
pub fn familiarRecoverCount(self: @This()) u8 {
    return self.row.at(u8, 0);
}
