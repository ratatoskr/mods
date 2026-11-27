//! `CompanyCraftSequence`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ResultItem`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanyCraftSequence = @This();

pub const sheet_name = "CompanyCraftSequence";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6d444cc1;
pub const Sheet = excel.Typed(CompanyCraftSequence);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ResultItem", "Category", "CompanyCraftDraftCategory", "CompanyCraftType", "CompanyCraftDraft", "CompanyCraftPart[0]", "CompanyCraftPart[1]", "CompanyCraftPart[2]", "CompanyCraftPart[3]", "CompanyCraftPart[4]", "CompanyCraftPart[5]", "CompanyCraftPart[6]", "CompanyCraftPart[7]", "Order" };

pub fn order(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Item`.
pub fn resultItem(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 4));
}

pub fn category(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `CompanyCraftDraftCategory`.
pub fn companyCraftDraftCategory(self: @This()) excel.Link(sheets.CompanyCraftDraftCategory) {
    return .of(self.row.at(i32, 12));
}

/// Links to `CompanyCraftType`.
pub fn companyCraftType(self: @This()) excel.Link(sheets.CompanyCraftType) {
    return .of(self.row.at(i32, 16));
}

/// Links to `CompanyCraftDraft`.
pub fn companyCraftDraft(self: @This()) excel.Link(sheets.CompanyCraftDraft) {
    return .of(self.row.at(i32, 20));
}

pub const company_craft_part_len = 8;
/// Links to `CompanyCraftPart`.
pub fn companyCraftPart(self: @This(), n0: usize) excel.Link(sheets.CompanyCraftPart) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [8]u16{ 24, 26, 28, 30, 32, 34, 36, 38 };
