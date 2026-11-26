//! `WKSFateControl`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSFateControl = @This();

pub const sheet_name = "WKSFateControl";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x49c8f3d3;
pub const Sheet = excel.Typed(WKSFateControl);

row: excel.Row,

pub fn startupText(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn runningText(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 8);
}
