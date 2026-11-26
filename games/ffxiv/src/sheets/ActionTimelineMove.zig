//! `ActionTimelineMove`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ActionTimelineMove = @This();

pub const sheet_name = "ActionTimelineMove";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x94cee17e;
pub const Sheet = excel.Typed(ActionTimelineMove);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(6, 0);
}
