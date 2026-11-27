//! `WKSPioneeringTrailString`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `DevelopmentLogName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSPioneeringTrailString = @This();

pub const sheet_name = "WKSPioneeringTrailString";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7f711762;
pub const Sheet = excel.Typed(WKSPioneeringTrailString);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "DevelopmentLogText", "DevelopmentLogName", "DevelopmentLogDescription" };

pub fn developmentLogText(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn developmentLogName(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn developmentLogDescription(self: @This()) []const u8 {
    return self.row.stringAt(8);
}
