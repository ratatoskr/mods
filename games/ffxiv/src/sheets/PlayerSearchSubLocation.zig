//! `PlayerSearchSubLocation`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name0`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const PlayerSearchSubLocation = @This();

pub const sheet_name = "PlayerSearchSubLocation";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x16a4252d;
pub const Sheet = excel.Typed(PlayerSearchSubLocation);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SortKey", "PlaceName", "Location", "Name0", "Name1", "Name2" };

pub fn name0(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn name1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn name2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(i32, 12));
}

/// The UI category this appears in.
/// Links to `PlayerSearchLocation`.
pub fn location(self: @This()) excel.Link(sheets.PlayerSearchLocation) {
    return .of(self.row.at(i32, 16));
}

pub fn sortKey(self: @This()) u8 {
    return self.row.at(u8, 20);
}
