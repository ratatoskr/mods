//! `EventPathMove`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const EventPathMove = @This();

pub const sheet_name = "EventPathMove";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb5e8d87a;
pub const Sheet = excel.Typed(EventPathMove);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Unknown8", "Unknown11", "Unknown10", "Unknown9", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown0", "Unknown1" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown5(self: @This()) u32 {
    return self.row.at(u32, 20);
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unknown7(self: @This()) u32 {
    return self.row.at(u32, 28);
}

pub fn unknown8(self: @This()) u16 {
    return self.row.at(u16, 32);
}

pub fn unknown9(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn unknown10(self: @This()) u8 {
    return self.row.at(u8, 36);
}

pub fn unknown11(self: @This()) bool {
    return self.row.bitAt(37, 0);
}
