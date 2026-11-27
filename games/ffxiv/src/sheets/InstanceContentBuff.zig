//! `InstanceContentBuff`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InstanceContentBuff = @This();

pub const sheet_name = "InstanceContentBuff";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(InstanceContentBuff);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EchoStart", "EchoDeath" };

pub fn echoStart(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn echoDeath(self: @This()) u16 {
    return self.row.at(u16, 2);
}
