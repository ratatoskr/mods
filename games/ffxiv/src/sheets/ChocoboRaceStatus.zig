//! `ChocoboRaceStatus`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Status`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceStatus = @This();

pub const sheet_name = "ChocoboRaceStatus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf8ab135e;
pub const Sheet = excel.Typed(ChocoboRaceStatus);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Status", "VFX" };

/// Links to `Status`.
pub fn status(self: @This()) excel.Link(sheets.Status) {
    return .of(self.row.at(i32, 0));
}

/// Links to `VFX`.
pub fn vfx(self: @This()) excel.Link(sheets.VFX) {
    return .of(self.row.at(u16, 4));
}
