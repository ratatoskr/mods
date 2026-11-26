//! `MainCommand`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MainCommand = @This();

pub const sheet_name = "MainCommand";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc6604a03;
pub const Sheet = excel.Typed(MainCommand);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn category(self: @This()) u8 {
    return self.row.at(u8, 12);
}

/// Links to `MainCommandCategory`.
pub fn mainCommandCategory(self: @This()) excel.Link(sheets.MainCommandCategory) {
    return .of(self.row.at(u8, 13));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn sortID(self: @This()) i8 {
    return self.row.at(i8, 15);
}
