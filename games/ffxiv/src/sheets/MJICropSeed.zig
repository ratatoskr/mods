//! `MJICropSeed`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJICropSeed = @This();

pub const sheet_name = "MJICropSeed";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcd7b9ae9;
pub const Sheet = excel.Typed(MJICropSeed);

row: excel.Row,

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `EObjName`.
pub fn name(self: @This()) excel.Link(sheets.EObjName) {
    return .of(self.row.at(u32, 4));
}

/// Links to `ExportedSG`.
pub fn sgb(self: @This()) excel.Link(sheets.ExportedSG) {
    return .of(self.row.at(u16, 8));
}
