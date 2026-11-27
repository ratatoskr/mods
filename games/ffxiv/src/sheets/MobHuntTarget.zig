//! `MobHuntTarget`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MobHuntTarget = @This();

pub const sheet_name = "MobHuntTarget";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x83a7f541;
pub const Sheet = excel.Typed(MobHuntTarget);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Name", "FATE", "Icon", "Map", "PlaceName" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `BNpcName`.
pub fn name(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u16, 4));
}

/// Links to `Fate`.
pub fn fate(self: @This()) excel.Link(sheets.Fate) {
    return .of(self.row.at(u16, 6));
}

/// Links to `Map`.
pub fn map(self: @This()) excel.Link(sheets.Map) {
    return .of(self.row.at(u16, 8));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, 10));
}
