//! `ActionParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionParam = @This();

pub const sheet_name = "ActionParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8795cd75;
pub const Sheet = excel.Typed(ActionParam);

row: excel.Row,

pub fn name(self: @This()) i16 {
    return self.row.at(i16, 0);
}

pub fn unknown0(self: @This()) i16 {
    return self.row.at(i16, 2);
}
