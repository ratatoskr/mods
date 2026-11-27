//! `AirshipSkyIsland`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const AirshipSkyIsland = @This();

pub const sheet_name = "AirshipSkyIsland";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xbf6083ac;
pub const Sheet = excel.Typed(AirshipSkyIsland);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "Unknown2", "Unknown4", "Unknown3", "Unknown5" };

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
