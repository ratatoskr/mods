//! `ExVersion`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ExVersion = @This();

pub const sheet_name = "ExVersion";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdb31122b;
pub const Sheet = excel.Typed(ExVersion);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Equivalent to the last quest in column 6 of ScenarioTree
pub fn menuScreen(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Can be used in various places for UI elements.
/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// Links to `ScreenImage`.
pub fn acceptJingle(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u16, 12));
}

/// Links to `ScreenImage`.
pub fn completeJingle(self: @This()) excel.Link(sheets.ScreenImage) {
    return .of(self.row.at(u16, 14));
}
