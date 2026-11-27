//! `QuestDerivedClass`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ClassJob`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestDerivedClass = @This();

pub const sheet_name = "QuestDerivedClass";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xdcfd9eba;
pub const Sheet = excel.Typed(QuestDerivedClass);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{"ClassJob"};

/// Links to `ClassJob`.
pub fn classJob(self: @This()) excel.Link(sheets.ClassJob) {
    return .of(self.row.at(u8, 0));
}
