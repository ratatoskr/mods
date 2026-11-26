//! `MJIKeyItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIKeyItem = @This();

pub const sheet_name = "MJIKeyItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfc266fec;
pub const Sheet = excel.Typed(MJIKeyItem);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 0));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 4);
}
