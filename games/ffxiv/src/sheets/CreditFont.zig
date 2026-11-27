//! `CreditFont`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CreditFont = @This();

pub const sheet_name = "CreditFont";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xf8dfde72;
pub const Sheet = excel.Typed(CreditFont);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown3", "Unknown4", "Unknown5", "Unknown6", "Unknown7", "Unknown8" };

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 0);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 1);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 2);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 3);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown6(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown7(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn unknown8(self: @This()) i8 {
    return self.row.at(i8, 8);
}
