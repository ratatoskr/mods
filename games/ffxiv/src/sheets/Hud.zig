//! `Hud`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `DisplayName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Hud = @This();

pub const sheet_name = "Hud";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7f711762;
pub const Sheet = excel.Typed(Hud);

row: excel.Row,

pub fn displayName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn addonName(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}
