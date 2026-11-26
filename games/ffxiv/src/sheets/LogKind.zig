//! `LogKind`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LogKind = @This();

pub const sheet_name = "LogKind";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x160d7d57;
pub const Sheet = excel.Typed(LogKind);

row: excel.Row,

pub fn format(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(6, 0);
}
