//! `DescriptionSection`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `String`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DescriptionSection = @This();

pub const sheet_name = "DescriptionSection";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(DescriptionSection);

row: excel.Row,

/// Links to `DescriptionString`.
pub fn string(self: @This()) excel.Link(sheets.DescriptionString) {
    return .of(self.row.at(u16, 0));
}

/// Links to `DescriptionPage`.
pub fn page(self: @This()) excel.Link(sheets.DescriptionPage) {
    return .of(self.row.at(u16, 2));
}
