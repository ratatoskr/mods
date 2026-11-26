//! `Relic3Materia`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Relic3Materia = @This();

pub const sheet_name = "Relic3Materia";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5c71f84e;
pub const Sheet = excel.Typed(Relic3Materia);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 2);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown3(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown4(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 10);
}

pub fn unknown6(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn unknown7(self: @This()) i8 {
    return self.row.at(i8, 13);
}

pub fn unknown8(self: @This()) i8 {
    return self.row.at(i8, 14);
}
