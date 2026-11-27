//! `QuestAcceptAdditionCondition`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const QuestAcceptAdditionCondition = @This();

pub const sheet_name = "QuestAcceptAdditionCondition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xaa35fea3;
pub const Sheet = excel.Typed(QuestAcceptAdditionCondition);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Requirement0", "Requirement1", "Unknown0", "Unknown1" };

/// Links to `Quest`.
pub fn requirement0(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `Quest`.
pub fn requirement1(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(12, 0);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(12, 1);
}
