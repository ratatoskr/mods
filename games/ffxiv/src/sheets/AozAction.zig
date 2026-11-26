//! `AozAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Action`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AozAction = @This();

pub const sheet_name = "AozAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5a516458;
pub const Sheet = excel.Typed(AozAction);

row: excel.Row,

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u32, 0));
}

pub fn rank(self: @This()) u8 {
    return self.row.at(u8, 4);
}
