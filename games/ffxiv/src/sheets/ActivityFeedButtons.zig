//! `ActivityFeedButtons`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActivityFeedButtons = @This();

pub const sheet_name = "ActivityFeedButtons";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x20072d40;
pub const Sheet = excel.Typed(ActivityFeedButtons);

row: excel.Row,

pub fn bannerURL(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn language(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn pictureURL(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 16);
}
