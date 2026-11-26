//! `ReactionEventObjectInfo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ReactionEventObjectInfo = @This();

pub const sheet_name = "ReactionEventObjectInfo";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(ReactionEventObjectInfo);

row: excel.Row,

/// Links to `EObj` or `EObjName`, whichever has the row.
pub fn eObj(self: @This()) u32 {
    return self.row.at(u32, 0);
}
