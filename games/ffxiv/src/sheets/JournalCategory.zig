//! `JournalCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const JournalCategory = @This();

pub const sheet_name = "JournalCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd0118314;
pub const Sheet = excel.Typed(JournalCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "SeparateType", "DataType", "JournalSection", "MapCondition" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn separateType(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn dataType(self: @This()) u8 {
    return self.row.at(u8, 5);
}

/// Links to `JournalSection`.
pub fn journalSection(self: @This()) excel.Link(sheets.JournalSection) {
    return .of(self.row.at(u8, 6));
}

/// Links to `MapCondition`.
pub fn mapCondition(self: @This()) excel.Link(sheets.MapCondition) {
    return .of(self.row.at(u8, 7));
}
