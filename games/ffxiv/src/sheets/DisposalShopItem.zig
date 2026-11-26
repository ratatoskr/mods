//! `DisposalShopItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ItemDisposed`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DisposalShopItem = @This();

pub const sheet_name = "DisposalShopItem";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x1990ed53;
pub const Sheet = excel.Typed(DisposalShopItem);

row: excel.Row,

pub fn quantityReceived(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Item`.
pub fn itemDisposed(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 4));
}

/// Links to `Item`.
pub fn itemReceived(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 8));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn disposedHq(self: @This()) bool {
    return self.row.bitAt(14, 0);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(14, 1);
}
