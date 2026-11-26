//! `FieldMarker`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FieldMarker = @This();

pub const sheet_name = "FieldMarker";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x23003392;
pub const Sheet = excel.Typed(FieldMarker);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `VFX`.
pub fn vfx(self: @This()) excel.Link(sheets.VFX) {
    return .of(self.row.at(i32, 4));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn uiIcon(self: @This()) u16 {
    return self.row.at(u16, 8);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn mapIcon(self: @This()) u16 {
    return self.row.at(u16, 10);
}
