//! `EurekaDungeonPortal`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EurekaDungeonPortal = @This();

pub const sheet_name = "EurekaDungeonPortal";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(EurekaDungeonPortal);

row: excel.Row,

/// Links to `Level`.
pub fn level(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(u32, 0));
}
