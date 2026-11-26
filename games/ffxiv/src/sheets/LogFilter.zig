//! `LogFilter`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const LogFilter = @This();

pub const sheet_name = "LogFilter";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6ef5ba16;
pub const Sheet = excel.Typed(LogFilter);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn example(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn caster(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn target(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn logKind(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn category(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn displayOrder(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn preset(self: @This()) u8 {
    return self.row.at(u8, 15);
}
