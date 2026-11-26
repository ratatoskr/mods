//! `RideShootingTargetType`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RideShootingTargetType = @This();

pub const sheet_name = "RideShootingTargetType";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x213f343d;
pub const Sheet = excel.Typed(RideShootingTargetType);

row: excel.Row,

/// Links to `EObj`.
pub fn eObj(self: @This()) excel.Link(sheets.EObj) {
    return .of(self.row.at(u32, 0));
}

pub fn score(self: @This()) i16 {
    return self.row.at(i16, 4);
}

pub fn unknown0(self: @This()) i16 {
    return self.row.at(i16, 6);
}

pub fn unknown1(self: @This()) i16 {
    return self.row.at(i16, 8);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 10);
}

pub fn unknown3(self: @This()) i16 {
    return self.row.at(i16, 12);
}
