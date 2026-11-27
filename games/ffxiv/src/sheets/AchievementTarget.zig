//! `AchievementTarget`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Value`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AchievementTarget = @This();

pub const sheet_name = "AchievementTarget";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5bfa8a4e;
pub const Sheet = excel.Typed(AchievementTarget);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Type", "Value" };

pub fn value(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 4);
}
