//! `OrnamentAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OrnamentAction = @This();

pub const sheet_name = "OrnamentAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x58822da3;
pub const Sheet = excel.Typed(OrnamentAction);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Actions[0]", "Actions[1]", "Actions[2]", "Actions[3]", "Actions[4]", "Actions[5]" };

pub const actions_len = 6;
/// Links to `Action`.
pub fn actions(self: @This(), n0: usize) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [6]u16{ 0, 2, 4, 6, 8, 10 };
