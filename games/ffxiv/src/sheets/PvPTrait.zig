//! `PvPTrait`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PvPTrait = @This();

pub const sheet_name = "PvPTrait";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdc23efe7;
pub const Sheet = excel.Typed(PvPTrait);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Trait1", "Trait2", "Trait3" };

/// Links to `Trait`.
pub fn trait1(self: @This()) excel.Link(sheets.Trait) {
    return .of(self.row.at(u16, 0));
}

/// Links to `Trait`.
pub fn trait2(self: @This()) excel.Link(sheets.Trait) {
    return .of(self.row.at(u16, 2));
}

/// Links to `Trait`.
pub fn trait3(self: @This()) excel.Link(sheets.Trait) {
    return .of(self.row.at(u16, 4));
}
