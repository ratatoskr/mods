//! `ChocoboTaxiStand`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `PlaceName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboTaxiStand = @This();

pub const sheet_name = "ChocoboTaxiStand";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x233d23d9;
pub const Sheet = excel.Typed(ChocoboTaxiStand);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "TargetLocations[0]", "TargetLocations[1]", "TargetLocations[2]", "TargetLocations[3]", "TargetLocations[4]", "TargetLocations[5]", "TargetLocations[6]", "TargetLocations[7]", "PlaceName" };

pub fn placeName(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub const target_locations_len = 8;
/// Links to `ChocoboTaxi`.
pub fn targetLocations(self: @This(), n0: usize) excel.Link(sheets.ChocoboTaxi) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

const offsets_1 = [8]u16{ 4, 6, 8, 10, 12, 14, 16, 18 };
