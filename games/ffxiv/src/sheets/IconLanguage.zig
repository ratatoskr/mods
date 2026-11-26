//! `IconLanguage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IconLanguage = @This();

pub const sheet_name = "IconLanguage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xca511f36;
pub const Sheet = excel.Typed(IconLanguage);

row: excel.Row,

pub fn unknown0(self: @This()) bool {
    return self.row.at(u8, 0) != 0;
}

pub fn unknown1(self: @This()) bool {
    return self.row.at(u8, 1) != 0;
}

pub fn unknown2(self: @This()) bool {
    return self.row.at(u8, 2) != 0;
}

pub fn unknown3(self: @This()) bool {
    return self.row.at(u8, 3) != 0;
}

pub fn unknown4(self: @This()) bool {
    return self.row.at(u8, 4) != 0;
}

pub fn unknown5(self: @This()) bool {
    return self.row.at(u8, 5) != 0;
}

pub fn unknown6(self: @This()) bool {
    return self.row.at(u8, 6) != 0;
}

pub fn unknown7(self: @This()) bool {
    return self.row.at(u8, 7) != 0;
}

pub fn unknown8(self: @This()) bool {
    return self.row.at(u8, 8) != 0;
}

pub fn unknown9(self: @This()) bool {
    return self.row.at(u8, 9) != 0;
}
