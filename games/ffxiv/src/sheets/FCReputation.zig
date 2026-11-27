//! `FCReputation`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FCReputation = @This();

pub const sheet_name = "FCReputation";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3d6be37e;
pub const Sheet = excel.Typed(FCReputation);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "PointsToNext", "RequiredPoints", "DiscountRate", "Color", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn pointsToNext(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn requiredPoints(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// Links to `UIColor`.
pub fn color(self: @This()) excel.Link(sheets.UIColor) {
    return .of(self.row.at(u32, 12));
}

pub fn discountRate(self: @This()) u8 {
    return self.row.at(u8, 16);
}
