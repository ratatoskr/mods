//! `TraitRecast`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Trait`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TraitRecast = @This();

pub const sheet_name = "TraitRecast";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdc23efe7;
pub const Sheet = excel.Typed(TraitRecast);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Trait", "Action", "Timeds" };

/// Links to `Trait`.
pub fn trait(self: @This()) excel.Link(sheets.Trait) {
    return .of(self.row.at(u16, 0));
}

/// Links to `Action`.
pub fn action(self: @This()) excel.Link(sheets.Action) {
    return .of(self.row.at(u16, 2));
}

pub fn timeds(self: @This()) u16 {
    return self.row.at(u16, 4);
}
