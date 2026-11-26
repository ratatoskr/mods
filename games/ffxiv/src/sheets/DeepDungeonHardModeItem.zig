//! `DeepDungeonHardModeItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeonHardModeItem = @This();

pub const sheet_name = "DeepDungeonHardModeItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xeacbfc68;
pub const Sheet = excel.Typed(DeepDungeonHardModeItem);

row: excel.Row,

pub fn unknown0(self: @This()) u64 {
    return self.row.at(u64, 0);
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 12);
}
