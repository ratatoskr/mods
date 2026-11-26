//! `Relic3Rate`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Relic3Rate = @This();

pub const sheet_name = "Relic3Rate";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc5b95f3a;
pub const Sheet = excel.Typed(Relic3Rate);

row: excel.Row,

pub fn unknown0(self: @This()) i8 {
    return self.row.at(i8, 0);
}

pub fn unknown1(self: @This()) i8 {
    return self.row.at(i8, 1);
}

pub fn unknown2(self: @This()) i8 {
    return self.row.at(i8, 2);
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 3);
}

pub fn unknown4(self: @This()) i8 {
    return self.row.at(i8, 4);
}

pub fn unknown5(self: @This()) i8 {
    return self.row.at(i8, 5);
}

pub fn unknown6(self: @This()) i8 {
    return self.row.at(i8, 6);
}

pub fn unknown7(self: @This()) i8 {
    return self.row.at(i8, 7);
}

pub fn unknown8(self: @This()) i8 {
    return self.row.at(i8, 8);
}
