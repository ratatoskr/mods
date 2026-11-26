//! `PvPRankTransient`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPRankTransient = @This();

pub const sheet_name = "PvPRankTransient";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe93b7196;
pub const Sheet = excel.Typed(PvPRankTransient);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown3(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn unknown4(self: @This()) []const u8 {
    return self.row.stringAt(16);
}

pub fn unknown5(self: @This()) []const u8 {
    return self.row.stringAt(20);
}
