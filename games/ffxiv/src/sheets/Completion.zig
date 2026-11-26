//! `Completion`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Completion = @This();

pub const sheet_name = "Completion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2e6c55a3;
pub const Sheet = excel.Typed(Completion);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn groupTitle(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn lookupTable(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn group(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn key(self: @This()) u16 {
    return self.row.at(u16, 14);
}
