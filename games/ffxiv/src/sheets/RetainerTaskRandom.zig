//! `RetainerTaskRandom`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RetainerTaskRandom = @This();

pub const sheet_name = "RetainerTaskRandom";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9ab94c53;
pub const Sheet = excel.Typed(RetainerTaskRandom);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Requirement" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn requirement(self: @This()) i16 {
    return self.row.at(i16, 4);
}
