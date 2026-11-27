//! `BNpcBasePopVfx`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BNpcBasePopVfx = @This();

pub const sheet_name = "BNpcBasePopVfx";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(BNpcBasePopVfx);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Unknown0"};

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}
