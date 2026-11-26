//! `TreasureSpot`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Location`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TreasureSpot = @This();

pub const sheet_name = "TreasureSpot";
pub const kind: excel.Header.Kind = .subrows;
pub const columns_hash: u32 = 0x4a63eb8e;
pub const Sheet = excel.Typed(TreasureSpot);

row: excel.Row,

pub fn mapOffsetX(self: @This()) f32 {
    return self.row.at(f32, 0);
}

pub fn mapOffsetY(self: @This()) f32 {
    return self.row.at(f32, 4);
}

/// Links to `Level`.
pub fn location(self: @This()) excel.Link(sheets.Level) {
    return .of(self.row.at(i32, 8));
}
