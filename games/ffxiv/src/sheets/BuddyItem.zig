//! `BuddyItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BuddyItem = @This();

pub const sheet_name = "BuddyItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfa9fc03d;
pub const Sheet = excel.Typed(BuddyItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "UseField", "UseTraining", "Unknown0", "Status" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u16, 0));
}

pub fn status(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn useField(self: @This()) bool {
    return self.row.bitAt(3, 0);
}

pub fn useTraining(self: @This()) bool {
    return self.row.bitAt(3, 1);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(3, 2);
}
