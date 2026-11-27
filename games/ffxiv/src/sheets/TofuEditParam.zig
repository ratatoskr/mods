//! `TofuEditParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TofuEditParam = @This();

pub const sheet_name = "TofuEditParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4e317fbc;
pub const Sheet = excel.Typed(TofuEditParam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "Default", "Minimum", "Maximum", "Unknown4" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn default(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn minimum(self: @This()) i16 {
    return self.row.at(i16, 6);
}

pub fn maximum(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(10, 0);
}
