//! `Title`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Feminine`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Title = @This();

pub const sheet_name = "Title";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x83e3f9ba;
pub const Sheet = excel.Typed(Title);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Masculine", "Feminine", "IsPrefix", "Order" };

pub fn masculine(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn feminine(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn isPrefix(self: @This()) bool {
    return self.row.bitAt(8, 0);
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 12);
}
