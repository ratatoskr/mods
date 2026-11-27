//! `CompanyCraftDraftCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CompanyCraftDraftCategory = @This();

pub const sheet_name = "CompanyCraftDraftCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf6570594;
pub const Sheet = excel.Typed(CompanyCraftDraftCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "CompanyCraftType[0]", "CompanyCraftType[1]", "CompanyCraftType[2]", "CompanyCraftType[3]", "CompanyCraftType[4]", "CompanyCraftType[5]", "CompanyCraftType[6]", "CompanyCraftType[7]", "CompanyCraftType[8]", "CompanyCraftType[9]" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const company_craft_type_len = 10;
/// Links to `CompanyCraftType`.
pub fn companyCraftType(self: @This(), n0: usize) excel.Link(sheets.CompanyCraftType) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [10]u16{ 4, 6, 8, 10, 12, 14, 16, 18, 20, 22 };
