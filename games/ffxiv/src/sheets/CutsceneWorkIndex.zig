//! `CutsceneWorkIndex`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CutsceneWorkIndex = @This();

pub const sheet_name = "CutsceneWorkIndex";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(CutsceneWorkIndex);

row: excel.Row,

pub fn workIndex(self: @This()) u16 {
    return self.row.at(u16, 0);
}
