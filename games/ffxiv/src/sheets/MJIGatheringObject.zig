//! `MJIGatheringObject`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIGatheringObject = @This();

pub const sheet_name = "MJIGatheringObject";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa0ca50af;
pub const Sheet = excel.Typed(MJIGatheringObject);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn mapIcon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// Links to `EObjName`.
pub fn name(self: @This()) excel.Link(sheets.EObjName) {
    return .of(self.row.at(u32, 8));
}

/// Links to `ExportedSG`.
pub fn sgb(self: @This()) excel.Link(sheets.ExportedSG) {
    return .of(self.row.at(u16, 12));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 14);
}
