//! `Lockon`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Lockon = @This();

pub const sheet_name = "Lockon";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8e477c70;
pub const Sheet = excel.Typed(Lockon);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "IconName", "Unknown1" };

pub fn iconName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(4, 0);
}
