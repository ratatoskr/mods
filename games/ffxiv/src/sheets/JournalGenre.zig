//! `JournalGenre`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const JournalGenre = @This();

pub const sheet_name = "JournalGenre";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2c6b75bb;
pub const Sheet = excel.Typed(JournalGenre);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Icon", "JournalCategory", "Unknown0", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 4);
}

/// Links to `JournalCategory`.
pub fn journalCategory(self: @This()) excel.Link(sheets.JournalCategory) {
    return .of(self.row.at(u8, 8));
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(9, 0);
}
