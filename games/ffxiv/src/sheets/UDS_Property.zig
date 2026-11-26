//! `UDS_Property`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const UDS_Property = @This();

pub const sheet_name = "UDS_Property";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9db0e48f;
pub const Sheet = excel.Typed(UDS_Property);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn @"type"(self: @This()) []const u8 {
    return self.row.stringAt(4);
}
