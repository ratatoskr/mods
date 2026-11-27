//! `MovieSubtitle`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MovieSubtitle = @This();

pub const sheet_name = "MovieSubtitle";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x07f99ad3;
pub const Sheet = excel.Typed(MovieSubtitle);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "StartTime", "EndTime" };

pub fn startTime(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn endTime(self: @This()) f32 {
    return self.row.at(f32, 4);
}
