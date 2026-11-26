//! `CollisionIdPallet`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CollisionIdPallet = @This();

pub const sheet_name = "CollisionIdPallet";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdc23efe7;
pub const Sheet = excel.Typed(CollisionIdPallet);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 4);
}
