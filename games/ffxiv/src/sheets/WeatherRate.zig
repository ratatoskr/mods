//! `WeatherRate`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeatherRate = @This();

pub const sheet_name = "WeatherRate";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x474abce2;
pub const Sheet = excel.Typed(WeatherRate);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Weather[0]", "Rate[0]", "Weather[1]", "Rate[1]", "Weather[2]", "Rate[2]", "Weather[3]", "Rate[3]", "Weather[4]", "Rate[4]", "Weather[5]", "Rate[5]", "Weather[6]", "Rate[6]", "Weather[7]", "Rate[7]" };

pub const weather_len = 8;
/// Links to `Weather`.
pub fn weather(self: @This(), n0: usize) excel.Link(sheets.Weather) {
    return .of(self.row.at(i32, offsets_1[n0]));
}

pub const rate_len = 8;
pub fn rate(self: @This(), n0: usize) u8 {
    return self.row.at(u8, offsets_2[n0]);
}

const offsets_1 = [8]u16{ 0, 4, 8, 12, 16, 20, 24, 28 };
const offsets_2 = [8]u16{ 32, 33, 34, 35, 36, 37, 38, 39 };
