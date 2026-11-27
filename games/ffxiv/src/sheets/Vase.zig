//! `Vase`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Vase = @This();

pub const sheet_name = "Vase";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5d58cc84;
pub const Sheet = excel.Typed(Vase);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "VaseFlowerStart", "VaseFlowerEnd" };

pub fn vaseFlowerStart(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn vaseFlowerEnd(self: @This()) u32 {
    return self.row.at(u32, 4);
}
