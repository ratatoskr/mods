//! `Channeling`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Channeling = @This();

pub const sheet_name = "Channeling";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6dfe9f55;
pub const Sheet = excel.Typed(Channeling);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "File", "WidthScale", "Unknown0", "Unknown1", "Unknown2", "Unknown_70" };

pub fn file(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn widthScale(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(5, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(5, 1);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(5, 2);
}

pub fn unknown_70(self: @This()) bool {
    return self.row.bitAt(5, 3);
}
