//! `GCScripShopCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GCScripShopCategory = @This();

pub const sheet_name = "GCScripShopCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9b330d8a;
pub const Sheet = excel.Typed(GCScripShopCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "GrandCompany", "Tier", "SubCategory" };

/// Links to `GrandCompany`.
pub fn grandCompany(self: @This()) excel.Link(sheets.GrandCompany) {
    return .of(self.row.at(i8, 0));
}

pub fn tier(self: @This()) i8 {
    return self.row.at(i8, 1);
}

pub fn subCategory(self: @This()) i8 {
    return self.row.at(i8, 2);
}
