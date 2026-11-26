//! `CabinetCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Category`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CabinetCategory = @This();

pub const sheet_name = "CabinetCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0d4b5075;
pub const Sheet = excel.Typed(CabinetCategory);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// Links to `Addon`.
pub fn category(self: @This()) excel.Link(sheets.Addon) {
    return .of(self.row.at(i32, 4));
}

pub fn menuOrder(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn hideOrder(self: @This()) u8 {
    return self.row.at(u8, 9);
}
