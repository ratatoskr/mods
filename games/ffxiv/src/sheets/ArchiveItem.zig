//! `ArchiveItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ArchiveItem = @This();

pub const sheet_name = "ArchiveItem";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x31b3477e;
pub const Sheet = excel.Typed(ArchiveItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "Unknown1", "Unknown2" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(6, 0);
}
