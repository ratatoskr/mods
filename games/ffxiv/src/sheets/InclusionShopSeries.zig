//! `InclusionShopSeries`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `SpecialShop`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InclusionShopSeries = @This();

pub const sheet_name = "InclusionShopSeries";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(InclusionShopSeries);

row: excel.Row,

/// Links to `SpecialShop`.
pub fn specialShop(self: @This()) excel.Link(sheets.SpecialShop) {
    return .of(self.row.at(u32, 0));
}
