//! `CutScreenImage`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CutScreenImage = @This();

pub const sheet_name = "CutScreenImage";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x96914cfe;
pub const Sheet = excel.Typed(CutScreenImage);

row: excel.Row,

pub fn image(self: @This()) i32 {
    return self.row.at(i32, 0);
}

pub fn unknown1(self: @This()) i32 {
    return self.row.at(i32, 4);
}

pub fn @"type"(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown0(self: @This()) i16 {
    return self.row.at(i16, 10);
}
