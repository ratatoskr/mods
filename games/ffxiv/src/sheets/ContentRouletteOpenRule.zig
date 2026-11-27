//! `ContentRouletteOpenRule`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentRouletteOpenRule = @This();

pub const sheet_name = "ContentRouletteOpenRule";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x985449ce;
pub const Sheet = excel.Typed(ContentRouletteOpenRule);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "HasDutyRequirements", "Type" };

pub fn @"type"(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn hasDutyRequirements(self: @This()) bool {
    return self.row.bitAt(4, 0);
}
