//! `CutActionTimeline`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CutActionTimeline = @This();

pub const sheet_name = "CutActionTimeline";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xa8b8495c;
pub const Sheet = excel.Typed(CutActionTimeline);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown2", "Unknown1", "Unknown4", "Unknown3" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 9);
}

pub fn unknown4(self: @This()) i8 {
    return self.row.at(i8, 10);
}
