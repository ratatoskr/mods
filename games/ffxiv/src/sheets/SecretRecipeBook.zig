//! `SecretRecipeBook`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SecretRecipeBook = @This();

pub const sheet_name = "SecretRecipeBook";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0c8db36c;
pub const Sheet = excel.Typed(SecretRecipeBook);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "Name" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 4));
}
