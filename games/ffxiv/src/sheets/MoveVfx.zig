//! `MoveVfx`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `VFXNormal`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MoveVfx = @This();

pub const sheet_name = "MoveVfx";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(MoveVfx);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "VFXNormal", "VFXWalking" };

/// Links to `VFX`.
pub fn vfxNormal(self: @This()) excel.Link(sheets.VFX) {
    return .of(self.row.at(u16, 0));
}

/// Links to `VFX`.
pub fn vfxWalking(self: @This()) excel.Link(sheets.VFX) {
    return .of(self.row.at(u16, 2));
}
