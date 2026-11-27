//! `Role`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Role = @This();

pub const sheet_name = "Role";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(Role);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Type"};

/// 1 = Tank, 2 = DPS, 3 = Healer
pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 0);
}
