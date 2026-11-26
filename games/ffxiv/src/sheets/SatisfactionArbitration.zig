//! `SatisfactionArbitration`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Quest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SatisfactionArbitration = @This();

pub const sheet_name = "SatisfactionArbitration";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x3f77b2e9;
pub const Sheet = excel.Typed(SatisfactionArbitration);

row: excel.Row,

/// Links to `Quest`.
pub fn quest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

pub fn satisfactionLevel(self: @This()) u8 {
    return self.row.at(u8, 4);
}

/// Links to `SatisfactionNpc`.
pub fn satisfactionNpc(self: @This()) excel.Link(sheets.SatisfactionNpc) {
    return .of(self.row.at(u8, 5));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 6);
}
