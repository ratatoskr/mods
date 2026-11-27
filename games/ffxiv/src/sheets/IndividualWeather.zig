//! `IndividualWeather`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IndividualWeather = @This();

pub const sheet_name = "IndividualWeather";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4532afe5;
pub const Sheet = excel.Typed(IndividualWeather);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "IndividualWeatherData[0].Weather", "IndividualWeatherData[1].Weather", "IndividualWeatherData[2].Weather", "IndividualWeatherData[3].Weather", "IndividualWeatherData[4].Weather", "IndividualWeatherData[5].Weather", "IndividualWeatherData[6].Weather", "IndividualWeatherData[0].Unknown1", "IndividualWeatherData[1].Unknown1", "IndividualWeatherData[2].Unknown1", "IndividualWeatherData[3].Unknown1", "IndividualWeatherData[4].Unknown1", "IndividualWeatherData[5].Unknown1", "IndividualWeatherData[6].Unknown1", "IndividualWeatherData[0].Quest", "IndividualWeatherData[1].Quest", "IndividualWeatherData[2].Quest", "IndividualWeatherData[3].Quest", "IndividualWeatherData[4].Quest", "IndividualWeatherData[5].Quest", "IndividualWeatherData[6].Quest", "IndividualWeatherData[0].Unknown0", "IndividualWeatherData[1].Unknown0", "IndividualWeatherData[2].Unknown0", "IndividualWeatherData[3].Unknown0", "IndividualWeatherData[4].Unknown0", "IndividualWeatherData[5].Unknown0", "IndividualWeatherData[6].Unknown0" };

pub const individual_weather_data_len = 7;
pub fn individualWeatherData(self: @This(), n0: usize) IndividualWeatherDataEntry {
    std.debug.assert(n0 < 7);
    return .{ .row = self.row, .at = .{
        @intCast(n0),
    } };
}

pub const IndividualWeatherDataEntry = struct {
    row: excel.Row,
    at: [1]u16,

    /// Links to `Quest`.
    pub fn quest(self: @This()) excel.Link(sheets.Quest) {
        return .of(self.row.at(u32, offsets_1[self.at[0]]));
    }

    /// quest progress maybe
    pub fn unknown0(self: @This()) u32 {
        return self.row.at(u32, offsets_2[self.at[0]]);
    }

    /// Links to `Weather`.
    pub fn weather(self: @This()) excel.Link(sheets.Weather) {
        return .of(self.row.at(u8, offsets_3[self.at[0]]));
    }

    pub fn unknown1(self: @This()) u8 {
        return self.row.at(u8, offsets_4[self.at[0]]);
    }
};

const offsets_1 = [7]u16{ 0, 12, 24, 36, 48, 60, 72 };
const offsets_2 = [7]u16{ 4, 16, 28, 40, 52, 64, 76 };
const offsets_3 = [7]u16{ 8, 20, 32, 44, 56, 68, 80 };
const offsets_4 = [7]u16{ 9, 21, 33, 45, 57, 69, 81 };
