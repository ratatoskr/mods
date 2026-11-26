//! `AetherialWheel`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AetherialWheel = @This();

pub const sheet_name = "AetherialWheel";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfee5acb6;
pub const Sheet = excel.Typed(AetherialWheel);

row: excel.Row,

/// Links to `Item`.
pub fn itemUnprimed(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

/// Links to `Item`.
pub fn itemPrimed(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 4));
}

pub fn grade(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn hoursRequired(self: @This()) u8 {
    return self.row.at(u8, 9);
}
