//! `TreasureHuntRank`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `ItemName`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const TreasureHuntRank = @This();

pub const sheet_name = "TreasureHuntRank";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x3997d502;
pub const Sheet = excel.Typed(TreasureHuntRank);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Unknown1", "Icon", "ItemName", "KeyItemName", "InstanceMap", "MaxPartySize", "TreasureHuntTexture", "Unknown0", "Unknown2" };

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Item`.
pub fn itemName(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 4));
}

/// Links to `EventItem`.
pub fn keyItemName(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(i32, 8));
}

/// Links to `EventItem`.
pub fn instanceMap(self: @This()) excel.Link(sheets.EventItem) {
    return .of(self.row.at(i32, 12));
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn maxPartySize(self: @This()) u8 {
    return self.row.at(u8, 19);
}

pub fn treasureHuntTexture(self: @This()) u8 {
    return self.row.at(u8, 20);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(21, 0);
}
