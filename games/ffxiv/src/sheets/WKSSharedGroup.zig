//! `WKSSharedGroup`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSSharedGroup = @This();

pub const sheet_name = "WKSSharedGroup";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x808df67e;
pub const Sheet = excel.Typed(WKSSharedGroup);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown5(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(12, 0);
}

pub fn unknown6(self: @This()) bool {
    return self.row.bitAt(12, 1);
}
