//! `CompanyCraftDraft`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanyCraftDraft = @This();

pub const sheet_name = "CompanyCraftDraft";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdf938294;
pub const Sheet = excel.Typed(CompanyCraftDraft);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "CompanyCraftDraftCategory", "RequiredItem[0]", "RequiredItemCount[0]", "RequiredItem[1]", "RequiredItemCount[1]", "RequiredItem[2]", "RequiredItemCount[2]", "Order" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn order(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub const required_item_len = 3;
/// Links to `Item`.
pub fn requiredItem(self: @This(), n0: usize) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

/// Links to `CompanyCraftDraftCategory`.
pub fn companyCraftDraftCategory(self: @This()) excel.Link(sheets.CompanyCraftDraftCategory) {
    return .of(self.row.at(u8, 20));
}

pub const required_item_count_len = 3;
pub fn requiredItemCount(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

const offsets_1 = [3]u16{ 8, 12, 16 };
const offsets_2 = [3]u16{ 21, 22, 23 };
