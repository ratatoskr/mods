//! `TiltParam`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TiltParam = @This();

pub const sheet_name = "TiltParam";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5e0ec373;
pub const Sheet = excel.Typed(TiltParam);

row: excel.Row,

pub fn tiltSpeed(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn rotationOrigin(self: @This()) u8 {
    return self.row.at(u8, 4);
}

pub fn tiltAngle(self: @This()) u8 {
    return self.row.at(u8, 5);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn reverseRotation(self: @This()) bool {
    return self.row.bitAt(8, 0);
}
