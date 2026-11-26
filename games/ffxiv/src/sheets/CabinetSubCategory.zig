//! `CabinetSubCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CabinetSubCategory = @This();

pub const sheet_name = "CabinetSubCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3d65a9f1;
pub const Sheet = excel.Typed(CabinetSubCategory);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn menuOrder(self: @This()) u16 {
    return self.row.at(u16, 4);
}
