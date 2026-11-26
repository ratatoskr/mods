//! `GCScripShopItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GCScripShopItem = @This();

pub const sheet_name = "GCScripShopItem";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x6c3dae69;
pub const Sheet = excel.Typed(GCScripShopItem);

row: excel.Row,

pub fn costGCSeals(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 4));
}

/// Links to `GrandCompanyRank`.
pub fn requiredGrandCompanyRank(self: @This()) excel.Link(sheets.GrandCompanyRank) {
    return .of(self.row.at(i32, 8));
}

pub fn sortKey(self: @This()) u8 {
    return self.row.at(u8, 12);
}
