//! `WeatherGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `WeatherRate`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WeatherGroup = @This();

pub const sheet_name = "WeatherGroup";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xfaedad07;
pub const Sheet = excel.Typed(WeatherGroup);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "WeatherRate" };

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// Links to `WeatherRate`.
pub fn weatherRate(self: @This()) excel.Link(sheets.WeatherRate) {
    return .of(self.row.at(i32, 4));
}
