//! `TerritoryAetheryteList`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `PlaceName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TerritoryAetheryteList = @This();

pub const sheet_name = "TerritoryAetheryteList";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0xdf2c4833;
pub const Sheet = excel.Typed(TerritoryAetheryteList);

row: excel.Row,

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u32, 0));
}

/// Links to `EObjName` or `EObj`, whichever has the row.
pub fn aetheryteObject(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unlockIndex(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn displayIndex(self: @This()) u8 {
    return self.row.at(u8, 10);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 11);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 12);
}
