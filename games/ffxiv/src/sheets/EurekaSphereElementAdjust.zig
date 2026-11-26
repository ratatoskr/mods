//! `EurekaSphereElementAdjust`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `PowerModifier`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EurekaSphereElementAdjust = @This();

pub const sheet_name = "EurekaSphereElementAdjust";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(EurekaSphereElementAdjust);

row: excel.Row,

pub fn powerModifier(self: @This()) u16 {
    return self.row.at(u16, 0);
}
