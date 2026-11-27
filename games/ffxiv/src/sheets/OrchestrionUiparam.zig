//! `OrchestrionUiparam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OrchestrionUiparam = @This();

pub const sheet_name = "OrchestrionUiparam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd73eab80;
pub const Sheet = excel.Typed(OrchestrionUiparam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "OrchestrionCategory", "Order" };

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 0);
}

/// Links to `OrchestrionCategory`.
pub fn orchestrionCategory(self: @This()) excel.Link(sheets.OrchestrionCategory) {
    return .of(self.row.at(u8, 2));
}
