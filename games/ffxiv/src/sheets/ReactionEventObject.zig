//! `ReactionEventObject`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ReactionEventObject = @This();

pub const sheet_name = "ReactionEventObject";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(ReactionEventObject);

row: excel.Row,

/// Links to `ReactionEventObjectInfo`.
pub fn objectInfo(self: @This()) excel.Link(sheets.ReactionEventObjectInfo) {
    return .of(self.row.at(u32, 0));
}

pub fn sharedGroup(self: @This()) u32 {
    return self.row.at(u32, 4);
}
