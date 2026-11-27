//! `RideShootingTarget`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const RideShootingTarget = @This();

pub const sheet_name = "RideShootingTarget";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x53c78910;
pub const Sheet = excel.Typed(RideShootingTarget);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown3", "Unknown4", "Unknown0", "Unknown1", "Unknown2", "Unknown5" };

pub fn unknown0(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 12);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 13);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 14);
}
