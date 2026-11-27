//! `SnipeTalk`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SnipeTalk = @This();

pub const sheet_name = "SnipeTalk";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcea69cac;
pub const Sheet = excel.Typed(SnipeTalk);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Unknown3", "Name", "Text", "Unknown0", "Unknown1" };

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

/// Links to `SnipeTalkName`.
pub fn name(self: @This()) excel.Link(sheets.SnipeTalkName) {
    return .of(self.row.at(u16, 12));
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 14);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 15);
}
