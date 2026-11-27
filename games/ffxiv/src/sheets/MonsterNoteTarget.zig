//! `MonsterNoteTarget`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `BNpcName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const MonsterNoteTarget = @This();

pub const sheet_name = "MonsterNoteTarget";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x4157404f;
pub const Sheet = excel.Typed(MonsterNoteTarget);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "BNpcName", "Icon", "Town", "PlaceNameZone[0]", "PlaceNameLocation[0]", "PlaceNameZone[1]", "PlaceNameLocation[1]", "PlaceNameZone[2]", "PlaceNameLocation[2]" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 0);
}

/// Links to `BNpcName`.
pub fn bNpcName(self: @This()) excel.Link(sheets.BNpcName) {
    return .of(self.row.at(u16, 4));
}

pub const place_name_zone_len = 3;
/// Links to `PlaceName`.
pub fn placeNameZone(self: @This(), n0: usize) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub const place_name_location_len = 3;
/// Links to `PlaceName`.
pub fn placeNameLocation(self: @This(), n0: usize) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u16, offsets_2[n0]));
}

/// Links to `Town`.
pub fn town(self: @This()) excel.Link(sheets.Town) {
    return .of(self.row.at(u8, 18));
}

const offsets_1 = [3]u16{ 6, 8, 10 };
const offsets_2 = [3]u16{ 12, 14, 16 };
