//! `TerritoryCandidates`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TerritoryCandidates = @This();

pub const sheet_name = "TerritoryCandidates";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xfc266fec;
pub const Sheet = excel.Typed(TerritoryCandidates);

row: excel.Row,

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 4);
}
