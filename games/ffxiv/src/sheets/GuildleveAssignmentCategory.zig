//! `GuildleveAssignmentCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GuildleveAssignmentCategory = @This();

pub const sheet_name = "GuildleveAssignmentCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xeb15b554;
pub const Sheet = excel.Typed(GuildleveAssignmentCategory);

row: excel.Row,

pub const category_len = 8;
/// Links to `LeveAssignmentType`.
pub fn category(self: @This(), n0: usize) excel.Link(sheets.LeveAssignmentType) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

const offsets_1 = [8]u16{ 0, 4, 8, 12, 16, 20, 24, 28 };
