//! `Adventure`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Adventure = @This();

pub const sheet_name = "Adventure";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc57bf748;
pub const Sheet = excel.Typed(Adventure);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Level", "MinLevel", "MaxLevel", "Emote", "WeatherCategory", "Weather", "MinTime", "MaxTime", "PlaceName", "IconList", "IconDiscovered", "IconUndiscovered", "IsInitial", "Name", "Impression", "Description" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn impression(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(i32, 12));
}

pub fn minLevel(self: @This()) i32 {
    return self.row.at(i32, 16);
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(i32, 20));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconList(self: @This()) i32 {
    return self.row.at(i32, 24);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconDiscovered(self: @This()) i32 {
    return self.row.at(i32, 28);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconUndiscovered(self: @This()) i32 {
    return self.row.at(i32, 32);
}

/// Links to `Emote`.
pub fn emote(self: @This()) excel.Link(sheets.Emote) {
    return .of(self.row.at(u16, 36));
}

pub fn minTime(self: @This()) u16 {
    return self.row.at(u16, 38);
}

pub fn maxTime(self: @This()) u16 {
    return self.row.at(u16, 40);
}

pub fn maxLevel(self: @This()) u8 {
    return self.row.at(u8, 42);
}

/// Links to `WeatherCategory`.
pub fn weatherCategory(self: @This()) excel.Link(sheets.WeatherCategory) {
    return .of(self.row.at(u8, 43));
}

/// Links to `Weather`.
pub fn weather(self: @This()) excel.Link(sheets.Weather) {
    return .of(self.row.at(u8, 44));
}

pub fn isInitial(self: @This()) bool {
    return self.row.bitAt(45, 0);
}
