//! `WKSMissionMapMarker`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionMapMarker = @This();

pub const sheet_name = "WKSMissionMapMarker";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7196d620;
pub const Sheet = excel.Typed(WKSMissionMapMarker);

row: excel.Row,

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn x(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn y(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn radius(self: @This()) u16 {
    return self.row.at(u16, 8);
}
