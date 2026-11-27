//! `ContentDirectorManagedSG`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentDirectorManagedSG = @This();

pub const sheet_name = "ContentDirectorManagedSG";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xed97494a;
pub const Sheet = excel.Typed(ContentDirectorManagedSG);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "LayoutId", "Unknown1" };

/// Refers to an SGB instance in the level.
pub fn layoutId(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(4, 0);
}
