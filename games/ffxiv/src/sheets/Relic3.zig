//! `Relic3`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ItemNovus`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Relic3 = @This();

pub const sheet_name = "Relic3";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xeb3c566a;
pub const Sheet = excel.Typed(Relic3);

row: excel.Row,

/// Links to `Item`.
pub fn itemAnimus(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Item`.
pub fn itemScroll(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Item`.
pub fn itemNovus(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn materiaLimit(self: @This()) u8 {
    return self.row.at(u8, 16);
}

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 17);
}
