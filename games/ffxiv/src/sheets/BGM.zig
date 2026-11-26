//! `BGM`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `File`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BGM = @This();

pub const sheet_name = "BGM";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc9fc6953;
pub const Sheet = excel.Typed(BGM);

row: excel.Row,

pub fn file(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn disableRestartResetTime(self: @This()) f32 {
    return self.row.at(f32, 4);
}

pub fn priority(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn specialMode(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn disableRestartTimeOut(self: @This()) bool {
    return self.row.bitAt(10, 0);
}

pub fn disableRestart(self: @This()) bool {
    return self.row.bitAt(10, 1);
}

pub fn passEnd(self: @This()) bool {
    return self.row.bitAt(10, 2);
}
