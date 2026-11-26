//! `MJILandmarkPlace`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJILandmarkPlace = @This();

pub const sheet_name = "MJILandmarkPlace";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6c5e3fc8;
pub const Sheet = excel.Typed(MJILandmarkPlace);

row: excel.Row,

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `EObjName`.
pub fn name(self: @This()) excel.Link(sheets.EObjName) {
    return .of(self.row.at(u32, 4));
}

pub const sgb_len = 2;
/// Links to `ExportedSG`.
pub fn sgb(self: @This(), n0: usize) excel.Link(sheets.ExportedSG) {
    return .of(self.row.at(u32, offsets_1[n0]));
}

pub fn unknown1(self: @This()) i16 {
    return self.row.at(i16, 16);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 18);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 20);
}

const offsets_1 = [2]u16{ 8, 12 };
