//! `TofuBg`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TofuBg = @This();

pub const sheet_name = "TofuBg";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe1a3ccb8;
pub const Sheet = excel.Typed(TofuBg);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown3", "Unknown2", "Icon", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(10, 0);
}
