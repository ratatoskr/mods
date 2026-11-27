//! `MiniGameTurnBreakAction`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MiniGameTurnBreakAction = @This();

pub const sheet_name = "MiniGameTurnBreakAction";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x59f9f073;
pub const Sheet = excel.Typed(MiniGameTurnBreakAction);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown2", "Unknown3", "Unknown5", "Unknown6", "Unknown7", "Unknown8", "Unknown9", "Unknown4", "Unknown0", "Unknown1" };

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown3(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn unknown4(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 21);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 22);
}

pub fn unknown8(self: @This()) u8 {
    return self.row.at(u8, 23);
}

pub fn unknown9(self: @This()) u8 {
    return self.row.at(u8, 24);
}
