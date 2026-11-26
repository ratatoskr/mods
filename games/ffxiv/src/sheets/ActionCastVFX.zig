//! `ActionCastVFX`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `VFX`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionCastVFX = @This();

pub const sheet_name = "ActionCastVFX";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(ActionCastVFX);

row: excel.Row,

/// Links to `VFX`.
pub fn vfx(self: @This()) excel.Link(sheets.VFX) {
    return .of(self.row.at(u16, 0));
}
