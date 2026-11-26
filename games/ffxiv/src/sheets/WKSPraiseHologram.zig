//! `WKSPraiseHologram`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSPraiseHologram = @This();

pub const sheet_name = "WKSPraiseHologram";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x3772605c;
pub const Sheet = excel.Typed(WKSPraiseHologram);

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

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 6);
}
