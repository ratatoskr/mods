//! `AddonParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AddonParam = @This();

pub const sheet_name = "AddonParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8e477c70;
pub const Sheet = excel.Typed(AddonParam);

row: excel.Row,

pub fn addonName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn param(self: @This()) bool {
    return self.row.bitAt(4, 0);
}
