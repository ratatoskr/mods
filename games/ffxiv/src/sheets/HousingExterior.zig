//! `HousingExterior`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const HousingExterior = @This();

pub const sheet_name = "HousingExterior";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xb56595e0;
pub const Sheet = excel.Typed(HousingExterior);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown0", "Unknown1", "PlaceName", "HousingSize", "Model" };

pub fn model(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 4));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 6);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 7);
}

pub fn housingSize(self: @This()) u8 {
    return self.row.at(u8, 8);
}
