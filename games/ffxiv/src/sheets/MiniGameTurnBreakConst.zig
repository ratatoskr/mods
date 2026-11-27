//! `MiniGameTurnBreakConst`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MiniGameTurnBreakConst = @This();

pub const sheet_name = "MiniGameTurnBreakConst";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(MiniGameTurnBreakConst);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Unknown0"};

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}
