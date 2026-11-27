//! `EventGimmickPathMove`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventGimmickPathMove = @This();

pub const sheet_name = "EventGimmickPathMove";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2550d0a0;
pub const Sheet = excel.Typed(EventGimmickPathMove);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "EventRange", "Unknown1", "Unknown5", "Unknown2", "Unknown3", "Unknown4" };

/// Refers to an instanced game object.
pub fn eventRange(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 14);
}
