//! `QuestSceneAbortConditionType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestSceneAbortConditionType = @This();

pub const sheet_name = "QuestSceneAbortConditionType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x317fcf4f;
pub const Sheet = excel.Typed(QuestSceneAbortConditionType);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2" };

pub fn unknown0(self: @This()) bool {
    return self.row.at(u8, 0) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 1) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 2) != 0;
}
