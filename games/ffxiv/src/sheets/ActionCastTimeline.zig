//! `ActionCastTimeline`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionCastTimeline = @This();

pub const sheet_name = "ActionCastTimeline";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2020acf6;
pub const Sheet = excel.Typed(ActionCastTimeline);

row: excel.Row,

/// Links to `ActionTimeline`.
pub fn name(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u16, 0));
}

/// Links to `VFX`.
pub fn vfx(self: @This()) excel.Link(sheets.VFX) {
    return .of(self.row.at(u16, 2));
}
