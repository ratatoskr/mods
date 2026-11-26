//! `TriggerEffect`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TriggerEffect = @This();

pub const sheet_name = "TriggerEffect";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xeb15b554;
pub const Sheet = excel.Typed(TriggerEffect);

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

pub fn unknown3(self: @This()) i32 {
    return self.row.at(i32, 12);
}

pub fn unknown4(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub fn unknown5(self: @This()) i32 {
    return self.row.at(i32, 20);
}

pub fn unknown6(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn unknown7(self: @This()) i32 {
    return self.row.at(i32, 28);
}
