//! `RecommendContents`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Level`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RecommendContents = @This();

pub const sheet_name = "RecommendContents";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe79dd9d4;
pub const Sheet = excel.Typed(RecommendContents);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Level", "ClassJob", "MinLevel", "MaxLevel" };

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(i32, 0));
}

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 4));
}

pub fn minLevel(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn maxLevel(self: @This()) u8 {
    return self.row.at(u8, 6);
}
