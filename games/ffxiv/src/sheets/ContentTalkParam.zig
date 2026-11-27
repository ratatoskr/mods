//! `ContentTalkParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ContentTalkParam = @This();

pub const sheet_name = "ContentTalkParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xd4cefacf;
pub const Sheet = excel.Typed(ContentTalkParam);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Param", "Unknown0", "TestAction", "Unknown2", "Unknown3", "Unknown1" };

/// Links to `ActionTimeline`.
pub fn testAction(self: @This()) excel.Link(sheets.ActionTimeline) {
    return .of(self.row.at(u32, 0));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown2(self: @This()) i8 {
    return self.row.at(i8, 6);
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 7);
}

pub fn param(self: @This()) bool {
    return self.row.bitAt(8, 0);
}
