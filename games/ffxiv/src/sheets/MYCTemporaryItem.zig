//! `MYCTemporaryItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Action`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MYCTemporaryItem = @This();

pub const sheet_name = "MYCTemporaryItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9176820b;
pub const Sheet = excel.Typed(MYCTemporaryItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Category", "Type", "Action", "Max", "Weight", "Order" };

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, 0));
}

/// Links to `MYCTemporaryItemUICategory`.
pub fn category(self: @This()) excel.Link(sheets.MYCTemporaryItemUICategory) {
    return .of(self.row.at(u8, 4));
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn max(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn weight(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 8);
}
