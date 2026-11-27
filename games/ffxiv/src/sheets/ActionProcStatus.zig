//! `ActionProcStatus`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Status`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionProcStatus = @This();

pub const sheet_name = "ActionProcStatus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(ActionProcStatus);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Status"};

/// Links to `Status`.
pub fn status(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(u16, 0));
}
