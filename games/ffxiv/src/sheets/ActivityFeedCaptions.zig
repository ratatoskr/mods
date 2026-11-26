//! `ActivityFeedCaptions`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActivityFeedCaptions = @This();

pub const sheet_name = "ActivityFeedCaptions";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x776ee24c;
pub const Sheet = excel.Typed(ActivityFeedCaptions);

row: excel.Row,

pub fn ja(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn en(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn de(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn fr(self: @This()) []const u8 {
    return self.row.stringAt(12);
}
