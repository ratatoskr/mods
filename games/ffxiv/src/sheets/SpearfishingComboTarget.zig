//! `SpearfishingComboTarget`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SpearfishingComboTarget = @This();

pub const sheet_name = "SpearfishingComboTarget";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7f711762;
pub const Sheet = excel.Typed(SpearfishingComboTarget);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown_70(self: @This()) []const u8 {
    return self.row.stringAt(8);
}
