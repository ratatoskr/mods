//! `AchievementCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AchievementCategory = @This();

pub const sheet_name = "AchievementCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb98d9baf;
pub const Sheet = excel.Typed(AchievementCategory);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `AchievementKind`.
pub fn achievementKind(self: @This()) excel.Link(sheets.AchievementKind) {
    return .of(self.row.at(u8, 4));
}

pub fn order(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn showComplete(self: @This()) bool {
    return self.row.bitAt(6, 0);
}

pub fn hideCategory(self: @This()) bool {
    return self.row.bitAt(6, 1);
}
