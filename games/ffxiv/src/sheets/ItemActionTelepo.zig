//! `ItemActionTelepo`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Requirement`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemActionTelepo = @This();

pub const sheet_name = "ItemActionTelepo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(ItemActionTelepo);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Requirement", "DenyMessage" };

/// Links to `Quest` or `GrandCompany`, whichever has the row.
pub fn requirement(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `LogMessage`.
pub fn denyMessage(self: @This()) excel.Link(sheets.LogMessage) {
    return .of(self.row.at(u32, 4));
}
