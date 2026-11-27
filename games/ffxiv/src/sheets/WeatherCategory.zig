//! `WeatherCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeatherCategory = @This();

pub const sheet_name = "WeatherCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x63c20db3;
pub const Sheet = excel.Typed(WeatherCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Weather[0]", "Weather[1]", "Weather[2]", "Weather[3]", "Weather[4]" };

pub const weather_len = 5;
/// Links to `Weather`.
pub fn weather(self: @This(), n0: usize) excel.Link(sheets.Weather) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

const offsets_1 = [5]u16{ 0, 4, 8, 12, 16 };
