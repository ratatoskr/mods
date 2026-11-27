//! `BuddyAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BuddyAction = @This();

pub const sheet_name = "BuddyAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9a695bec;
pub const Sheet = excel.Typed(BuddyAction);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Description", "Icon", "IconStatus", "UnlockLink", "Sort" };

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

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconStatus(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn unlockLink(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn sort(self: @This()) u8 {
    return self.row.at(u8, 18);
}
