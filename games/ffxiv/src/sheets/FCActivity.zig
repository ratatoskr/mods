//! `FCActivity`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Text`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FCActivity = @This();

pub const sheet_name = "FCActivity";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe45dc889;
pub const Sheet = excel.Typed(FCActivity);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn selfKind(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn targetKind(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn numParam(self: @This()) u8 {
    return self.row.at(u8, 6);
}

/// Links to `FCActivityCategory`.
pub fn fcActivityCategory(self: @This()) excel.Link(sheets.FCActivityCategory) {
    return .of(self.row.at(u8, 7));
}

pub fn iconType(self: @This()) i8 {
    return self.row.at(i8, 8);
}
