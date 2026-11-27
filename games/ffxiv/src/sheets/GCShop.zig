//! `GCShop`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GCShop = @This();

pub const sheet_name = "GCShop";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdd3ff48d;
pub const Sheet = excel.Typed(GCShop);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"GrandCompany"};

/// Links to `GrandCompany`.
pub fn grandCompany(self: @This()) excel.Link(sheets.GrandCompany) {
    return .of(self.row.at(i8, 0));
}
