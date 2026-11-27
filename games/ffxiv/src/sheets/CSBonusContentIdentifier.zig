//! `CSBonusContentIdentifier`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Content`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const CSBonusContentIdentifier = @This();

pub const sheet_name = "CSBonusContentIdentifier";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x8b9172ea;
pub const Sheet = excel.Typed(CSBonusContentIdentifier);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "ContentLinkType", "Content", "Unknown2", "UnlockQuest0", "UnlockQuest1", "UnlockQuest2", "Unknown6", "Map", "Icon" };

/// Links by `ContentLinkType`: 1 to `InstanceContent`, 2 to `GFateType`, 3 to `TerritoryType`, 4 to `MobHuntOrderType`, 5 to `TreasureHuntRank`, 6 to `FishParameter`, 7 to `ENpcResident`, 8 to `PublicContent`, 9 to `DeepDungeon`, 10 to `DynamicEvent`.
pub fn content(self: @This()) u32 {
    return self.row.at(u32, 0);
}

/// Links to `Quest`.
pub fn unlockQuest0(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Quest`.
pub fn unlockQuest1(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 8));
}

/// Links to `Quest`.
pub fn unlockQuest2(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 12));
}

pub fn unknown6(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// Links by `ContentLinkType`: 1 to `Level`, 2 to `Level`, 3 to `Fate`, 4 to `Level`, 7 to `Level`, 8 to `Level`, 9 to `Level`, 10 to `Level`.
pub fn map(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 24);
}

pub fn contentLinkType(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unknown2(self: @This()) bool {
    return self.row.bitAt(29, 0);
}
