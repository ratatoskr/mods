//! `DpsChallenge`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const DpsChallenge = @This();

pub const sheet_name = "DpsChallenge";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x2fdac054;
pub const Sheet = excel.Typed(DpsChallenge);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub fn playerLevel(self: @This()) u16 {
    return self.row.at(u16, 12);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 14);
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 16));
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn unknown1(self: @This()) bool {
    return self.row.bitAt(20, 0);
}
