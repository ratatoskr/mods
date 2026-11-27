//! `RacingChocoboItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RacingChocoboItem = @This();

pub const sheet_name = "RacingChocoboItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe79dd9d4;
pub const Sheet = excel.Typed(RacingChocoboItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "Category", "Unknown0", "Unknown1" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

pub fn category(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 6);
}
