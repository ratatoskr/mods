//! `HWDSharedGroupControlParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HWDSharedGroupControlParam = @This();

pub const sheet_name = "HWDSharedGroupControlParam";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xde74b4c4;
pub const Sheet = excel.Typed(HWDSharedGroupControlParam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "ParamValue" };

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn paramValue(self: @This()) u8 {
    return self.row.at(u8, 1);
}
