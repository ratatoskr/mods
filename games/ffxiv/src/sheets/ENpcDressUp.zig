//! `ENpcDressUp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ENpcDressUp = @This();

pub const sheet_name = "ENpcDressUp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xde74b4c4;
pub const Sheet = excel.Typed(ENpcDressUp);

row: excel.Row,

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

/// Links to `ENpcDressUpDress`.
pub fn eNpcDressUpDress(self: @This()) excel.Link(sheets.ENpcDressUpDress) {
    return .of(self.row.at(u8, 1));
}
