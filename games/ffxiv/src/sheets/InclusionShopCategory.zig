//! `InclusionShopCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const InclusionShopCategory = @This();

pub const sheet_name = "InclusionShopCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3b24d05f;
pub const Sheet = excel.Typed(InclusionShopCategory);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "ClassJobCategory", "InclusionShopSeries" };

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `InclusionShopSeries`.
pub fn inclusionShopSeries(self: @This()) excel.Link(sheets.InclusionShopSeries) {
    return .of(self.row.at(u16, 4));
}

/// Links to `ClassJobCategory`.
pub fn classJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 6));
}
