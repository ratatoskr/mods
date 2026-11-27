//! `WeatherReportReplace`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeatherReportReplace = @This();

pub const sheet_name = "WeatherReportReplace";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(WeatherReportReplace);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "PlaceNameSub", "PlaceNameParent" };

/// Links to `PlaceName`.
pub fn placeNameSub(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 0));
}

/// Links to `PlaceName`.
pub fn placeNameParent(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 2));
}
