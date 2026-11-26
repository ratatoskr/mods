//! `KineDriverOffGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const KineDriverOffGroup = @This();

pub const sheet_name = "KineDriverOffGroup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x53c2e05e;
pub const Sheet = excel.Typed(KineDriverOffGroup);

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
