//! `ChocoboTaxi`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Location`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const ChocoboTaxi = @This();

pub const sheet_name = "ChocoboTaxi";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x6a82513f;
pub const Sheet = excel.Typed(ChocoboTaxi);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Location", "TimeRequired", "Fare", "Unknown0", "Unknown1" };

/// Links to `ChocoboTaxiStand`.
pub fn location(self: @This()) excel.Link(sheets.ChocoboTaxiStand) {
    return .of(self.row.at(u32, 0));
}

pub fn fare(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 6);
}

/// In minutes.
pub fn timeRequired(self: @This()) u8 {
    return self.row.at(u8, 8);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(9, 0);
}
