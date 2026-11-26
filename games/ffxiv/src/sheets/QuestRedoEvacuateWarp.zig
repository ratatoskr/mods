//! `QuestRedoEvacuateWarp`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestRedoEvacuateWarp = @This();

pub const sheet_name = "QuestRedoEvacuateWarp";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(QuestRedoEvacuateWarp);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}
