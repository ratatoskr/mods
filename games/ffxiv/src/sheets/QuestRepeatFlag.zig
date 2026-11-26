//! `QuestRepeatFlag`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Quest`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestRepeatFlag = @This();

pub const sheet_name = "QuestRepeatFlag";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdbf43666;
pub const Sheet = excel.Typed(QuestRepeatFlag);

row: excel.Row,

/// Links to `ArrayEventHandler` or `Quest`, whichever has the row.
pub fn quest(self: @This()) u32 {
    return self.row.at(u32, 0);
}
