//! `QuestEffectDefine`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Effect`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestEffectDefine = @This();

pub const sheet_name = "QuestEffectDefine";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xd870e208;
pub const Sheet = excel.Typed(QuestEffectDefine);

row: excel.Row,

/// Links to `QuestEffect`.
pub fn effect(self: @This()) excel.Link(sheets.QuestEffect) {
    return .of(self.row.at(u16, 0));
}
