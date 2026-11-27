//! `ActivityFeedImages`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActivityFeedImages = @This();

pub const sheet_name = "ActivityFeedImages";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x530c5199;
pub const Sheet = excel.Typed(ActivityFeedImages);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ExpansionImage", "ActivityFeedJA", "ActivityFeedEN", "ActivityFeedDE", "ActivityFeedFR" };

pub fn expansionImage(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn activityFeedJA(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn activityFeedEN(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn activityFeedDE(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn activityFeedFR(self: @This()) []const u8 {
    return self.row.stringAt(16);
}
