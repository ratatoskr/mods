//! `CreditDataSet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CreditDataSet = @This();

pub const sheet_name = "CreditDataSet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcf2a6a87;
pub const Sheet = excel.Typed(CreditDataSet);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(18, 0);
}
