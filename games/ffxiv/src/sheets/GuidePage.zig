//! `GuidePage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GuidePage = @This();

pub const sheet_name = "GuidePage";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x7fcd4e75;
pub const Sheet = excel.Typed(GuidePage);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Key", "Unknown_70", "Output" };

/// Links by `Key`: 1 to `GuidePageString`, 2 to `GuidePageString`, 4 to `GuidePageString`, 5 to `GuidePageString`, 6 to `GuidePageString`.
pub fn output(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn key(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown_70(self: @This()) bool {
    return self.row.bitAt(5, 0);
}
