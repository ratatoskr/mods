//! `ChocoboRaceCalculateParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboRaceCalculateParam = @This();

pub const sheet_name = "ChocoboRaceCalculateParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xda365c51;
pub const Sheet = excel.Typed(ChocoboRaceCalculateParam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"Value"};

pub fn value(self: @This()) i32 {
    return self.row.at(i32, 0);
}
