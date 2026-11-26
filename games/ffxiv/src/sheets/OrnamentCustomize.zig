//! `OrnamentCustomize`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const OrnamentCustomize = @This();

pub const sheet_name = "OrnamentCustomize";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x9f62c1b0;
pub const Sheet = excel.Typed(OrnamentCustomize);

row: excel.Row,

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 0);
}

pub fn unknown1(self: @This()) i16 {
    return self.row.at(i16, 2);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn unknown3(self: @This()) i16 {
    return self.row.at(i16, 6);
}

pub fn unknown4(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown5(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn unknown6(self: @This()) i16 {
    return self.row.at(i16, 12);
}
