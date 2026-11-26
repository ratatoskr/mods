//! `FurnitureCatalogCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Category`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FurnitureCatalogCategory = @This();

pub const sheet_name = "FurnitureCatalogCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc8b7ab9b;
pub const Sheet = excel.Typed(FurnitureCatalogCategory);

row: excel.Row,

pub fn category(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 6);
}
