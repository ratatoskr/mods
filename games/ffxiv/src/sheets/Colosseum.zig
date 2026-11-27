//! `Colosseum`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Colosseum = @This();

pub const sheet_name = "Colosseum";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcfc59262;
pub const Sheet = excel.Typed(Colosseum);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1" };

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(1, 0);
}
