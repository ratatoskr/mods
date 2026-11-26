//! `ModelScale`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Scale`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ModelScale = @This();

pub const sheet_name = "ModelScale";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd16a1b6c;
pub const Sheet = excel.Typed(ModelScale);

row: excel.Row,

pub fn scale(self: @This()) f32 {
    return self.row.at(f32, 0);
}
