//! `IKDSpot`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `SpotMain`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const IKDSpot = @This();

pub const sheet_name = "IKDSpot";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x96a22aea;
pub const Sheet = excel.Typed(IKDSpot);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "SpotMain", "SpotSub", "PlaceName" };

/// Links to `FishingSpot`.
pub fn spotMain(self: @This()) excel.Link(sheets.FishingSpot) {
    return .of(self.row.at(u32, 0));
}

/// Links to `FishingSpot`.
pub fn spotSub(self: @This()) excel.Link(sheets.FishingSpot) {
    return .of(self.row.at(u32, 4));
}

/// Links to `PlaceName`.
pub fn placeName(self: @This()) excel.Link(sheets.PlaceName) {
    return .of(self.row.at(u32, 8));
}
