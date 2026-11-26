//! `MJIStockyardManagementTable`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Material`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIStockyardManagementTable = @This();

pub const sheet_name = "MJIStockyardManagementTable";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(MJIStockyardManagementTable);

row: excel.Row,

/// Links to `MJIItemPouch`.
pub fn material(self: @This()) excel.Link(sheets.MJIItemPouch) {
    return .of(self.row.at(u8, 0));
}
