//! `ConfigKey`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ConfigKey = @This();

pub const sheet_name = "ConfigKey";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x927ebfb7;
pub const Sheet = excel.Typed(ConfigKey);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Label", "Param", "Platform", "Required", "Category", "Unknown0", "BacklightColor", "Text" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn label(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn param(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn platform(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn category(self: @This()) u8 {
    return self.row.at(u8, 12);
}

/// Links to `BacklightColor`.
pub fn backlightColor(self: @This()) excel.Link(sheets.BacklightColor) {
    return .of(self.row.at(u8, 13));
}

pub fn required(self: @This()) bool {
    return self.row.bitAt(14, 0);
}
