//! `CraftType`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CraftType = @This();

pub const sheet_name = "CraftType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb92c9b70;
pub const Sheet = excel.Typed(CraftType);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn mainPhysical(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn subPhysical(self: @This()) u8 {
    return self.row.at(u8, 5);
}
