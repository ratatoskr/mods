//! `BGMSystemDefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Define`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BGMSystemDefine = @This();

pub const sheet_name = "BGMSystemDefine";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd16a1b6c;
pub const Sheet = excel.Typed(BGMSystemDefine);

row: excel.Row,

pub fn define(self: @This()) f32 {
    return self.row.at(f32, 0);
}
