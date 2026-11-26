//! `CreditBackImage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CreditBackImage = @This();

pub const sheet_name = "CreditBackImage";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x06eccbe2;
pub const Sheet = excel.Typed(CreditBackImage);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn backImage(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(9, 0);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(9, 1);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(9, 2);
}
