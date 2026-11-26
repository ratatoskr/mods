//! `WKSCosmoToolName`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSCosmoToolName = @This();

pub const sheet_name = "WKSCosmoToolName";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x77a72da0;
pub const Sheet = excel.Typed(WKSCosmoToolName);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown2(self: @This()) i8 {
    return self.row.at(i8, 8);
}

pub fn unknown3(self: @This()) i8 {
    return self.row.at(i8, 9);
}

pub fn unknown4(self: @This()) i8 {
    return self.row.at(i8, 10);
}

pub fn unknown5(self: @This()) i8 {
    return self.row.at(i8, 11);
}

pub fn unknown6(self: @This()) i8 {
    return self.row.at(i8, 12);
}

pub fn unknown7(self: @This()) i8 {
    return self.row.at(i8, 13);
}
