//! `MovieSubtitleVoyage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MovieSubtitleVoyage = @This();

pub const sheet_name = "MovieSubtitleVoyage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x07f99ad3;
pub const Sheet = excel.Typed(MovieSubtitleVoyage);

row: excel.Row,

pub fn startTime(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn endTime(self: @This()) f32 {
    return self.row.at(f32, 4);
}
