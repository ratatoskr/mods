//! `IKDRouteTable`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `IndigoRoute`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IKDRouteTable = @This();

pub const sheet_name = "IKDRouteTable";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(IKDRouteTable);

row: excel.Row,

/// Links to `IKDRoute`.
pub fn indigoRoute(self: @This()) excel.Link(sheets.IKDRoute) {
    return .of(self.row.at(u32, 0));
}

/// Links to `IKDRoute`.
pub fn rubyRoute(self: @This()) excel.Link(sheets.IKDRoute) {
    return .of(self.row.at(u32, 4));
}
