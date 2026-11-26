//! `ContentType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentType = @This();

pub const sheet_name = "ContentType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb19e831d;
pub const Sheet = excel.Typed(ContentType);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn iconDutyFinder(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 13);
}
