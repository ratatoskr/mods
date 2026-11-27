//! `ChocoboRaceWeather`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceWeather = @This();

pub const sheet_name = "ChocoboRaceWeather";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfaedad07;
pub const Sheet = excel.Typed(ChocoboRaceWeather);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "WeatherType1", "WeatherType2" };

/// Links to `Weather`.
pub fn weatherType1(self: @This()) excel.Link(sheets.Weather) {
    return .of(self.row.at(i32, 0));
}

/// Links to `Weather`.
pub fn weatherType2(self: @This()) excel.Link(sheets.Weather) {
    return .of(self.row.at(i32, 4));
}
