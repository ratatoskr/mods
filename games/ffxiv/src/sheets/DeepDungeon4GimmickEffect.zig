//! `DeepDungeon4GimmickEffect`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DeepDungeon4GimmickEffect = @This();

pub const sheet_name = "DeepDungeon4GimmickEffect";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x382abf74;
pub const Sheet = excel.Typed(DeepDungeon4GimmickEffect);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "StatusIcon" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn statusIcon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}
