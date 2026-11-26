//! `MiniGameTurnBreakStatus`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MiniGameTurnBreakStatus = @This();

pub const sheet_name = "MiniGameTurnBreakStatus";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x057e61f4;
pub const Sheet = excel.Typed(MiniGameTurnBreakStatus);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(14, 0);
}
