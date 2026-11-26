//! `MJIDisposalShopItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIDisposalShopItem = @This();

pub const sheet_name = "MJIDisposalShopItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xece42e62;
pub const Sheet = excel.Typed(MJIDisposalShopItem);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 3);
}

/// Links to `MJIDisposalShopUICategory`.
pub fn category(self: @This()) excel.Link(sheets.MJIDisposalShopUICategory) {
    return .of(self.row.at(u8, 4));
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 5);
}
