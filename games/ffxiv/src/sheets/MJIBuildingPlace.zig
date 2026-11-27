//! `MJIBuildingPlace`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MJIBuildingPlace = @This();

pub const sheet_name = "MJIBuildingPlace";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x369fb53b;
pub const Sheet = excel.Typed(MJIBuildingPlace);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Name", "SGB", "Unknown3", "Unknown1", "Unknown2" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `EObjName`.
pub fn name(self: @This()) excel.Link(sheets.EObjName) {
    return .of(self.row.at(u32, 4));
}

/// Links to `ExportedSG`.
pub fn sgb(self: @This()) excel.Link(sheets.ExportedSG) {
    return .of(self.row.at(u32, 8));
}

pub fn unknown1(self: @This()) i16 {
    return self.row.at(i16, 12);
}

pub fn unknown2(self: @This()) i16 {
    return self.row.at(i16, 14);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 16);
}
