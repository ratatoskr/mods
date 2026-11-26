//! `MJIGardenscaping`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIGardenscaping = @This();

pub const sheet_name = "MJIGardenscaping";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3554ffd5;
pub const Sheet = excel.Typed(MJIGardenscaping);

row: excel.Row,

pub fn unknown0(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn unknown2(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 12));
}

pub fn unknown3(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 22);
}

pub fn unknown6(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn level(self: @This()) u8 {
    return self.row.at(u8, 26);
}
