//! `FCAuthority`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FCAuthority = @This();

pub const sheet_name = "FCAuthority";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1ee79c01;
pub const Sheet = excel.Typed(FCAuthority);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `FCAuthorityCategory`.
pub fn fcAuthorityCategory(self: @This()) excel.Link(sheets.FCAuthorityCategory) {
    return .of(self.row.at(i32, 4));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 8);
}
