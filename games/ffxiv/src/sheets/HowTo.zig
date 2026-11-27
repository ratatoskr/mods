//! `HowTo`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HowTo = @This();

pub const sheet_name = "HowTo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe4488448;
pub const Sheet = excel.Typed(HowTo);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Announce", "HowToPagePC[0]", "HowToPagePC[1]", "HowToPagePC[2]", "HowToPagePC[3]", "HowToPagePC[4]", "HowToPageController[0]", "HowToPageController[1]", "HowToPageController[2]", "HowToPageController[3]", "HowToPageController[4]", "Category", "Sort" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const how_to_page_pc_len = 5;
/// Links to `HowToPage`.
pub fn howToPagePC(self: @This(), n0: usize) excel.Link(sheets.HowToPage) {
    return .of(self.row.at(i16, offsets_1[n0]));
}

pub const how_to_page_controller_len = 5;
/// Links to `HowToPage`.
pub fn howToPageController(self: @This(), n0: usize) excel.Link(sheets.HowToPage) {
    return .of(self.row.at(i16, offsets_2[n0]));
}

pub fn sort(self: @This()) u8 {
    return self.row.at(u8, 24);
}

/// Links to `HowToCategory`.
pub fn category(self: @This()) excel.Link(sheets.HowToCategory) {
    return .of(self.row.at(i8, 25));
}

pub fn announce(self: @This()) bool {
    return self.row.bitAt(26, 0);
}

const offsets_1 = [5]u16{ 4, 6, 8, 10, 12 };
const offsets_2 = [5]u16{ 14, 16, 18, 20, 22 };
