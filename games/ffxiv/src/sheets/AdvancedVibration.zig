//! `AdvancedVibration`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AdvancedVibration = @This();

pub const sheet_name = "AdvancedVibration";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfe115737;
pub const Sheet = excel.Typed(AdvancedVibration);

row: excel.Row,

pub fn unknown0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) []const u8 {
    return self.row.stringAt(8);
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
