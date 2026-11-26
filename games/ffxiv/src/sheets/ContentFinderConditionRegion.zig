//! `ContentFinderConditionRegion`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentFinderConditionRegion = @This();

pub const sheet_name = "ContentFinderConditionRegion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfc4febcd;
pub const Sheet = excel.Typed(ContentFinderConditionRegion);

row: excel.Row,

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 4);
}
