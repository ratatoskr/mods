//! `ContentsTutorial`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentsTutorial = @This();

pub const sheet_name = "ContentsTutorial";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x076bcd7d;
pub const Sheet = excel.Typed(ContentsTutorial);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Page[0]", "Page[1]", "Page[2]", "Page[3]", "Page[4]", "Page[5]", "Page[6]", "Page[7]", "Unknown1", "Name", "Description" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub const page_len = 8;
/// Links to `ContentsTutorialPage`.
pub fn page(self: @This(), n0: usize) excel.Link(sheets.ContentsTutorialPage) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

const offsets_1 = [8]u16{ 12, 16, 20, 24, 28, 32, 36, 40 };
