//! `TerritoryTypeTelepo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TerritoryTypeTelepo = @This();

pub const sheet_name = "TerritoryTypeTelepo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x33ff1cee;
pub const Sheet = excel.Typed(TerritoryTypeTelepo);

row: excel.Row,

pub fn x(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn y(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn expansion(self: @This()) u16 {
    return self.row.at(u16, 4);
}

/// Links to `TelepoRelay`.
pub fn relay(self: @This()) excel.Link(sheets.TelepoRelay) {
    return .of(self.row.at(u8, 6));
}
