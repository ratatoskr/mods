//! `RideShootingScheduler`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RideShootingScheduler = @This();

pub const sheet_name = "RideShootingScheduler";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x52d51fd2;
pub const Sheet = excel.Typed(RideShootingScheduler);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 16);
}
