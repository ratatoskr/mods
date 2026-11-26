//! `ItemOnceHqMasterpiece`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ItemOnceHqMasterpiece = @This();

pub const sheet_name = "ItemOnceHqMasterpiece";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x792adf2d;
pub const Sheet = excel.Typed(ItemOnceHqMasterpiece);

row: excel.Row,

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(0, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(0, 1);
}
