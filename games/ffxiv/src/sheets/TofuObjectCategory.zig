//! `TofuObjectCategory`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TofuObjectCategory = @This();

pub const sheet_name = "TofuObjectCategory";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xce3428a1;
pub const Sheet = excel.Typed(TofuObjectCategory);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown3(self: @This()) bool {
    return self.row.bitAt(7, 0);
}
