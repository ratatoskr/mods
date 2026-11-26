//! `MKDRelicGrowth2Monster`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MKDRelicGrowth2Monster = @This();

pub const sheet_name = "MKDRelicGrowth2Monster";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xc2fd317c;
pub const Sheet = excel.Typed(MKDRelicGrowth2Monster);

row: excel.Row,

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
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
