//! `GatheringItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const GatheringItem = @This();

pub const sheet_name = "GatheringItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x0b4dbede;
pub const Sheet = excel.Typed(GatheringItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "GatheringItemLevel", "Unknown4", "Unknown5", "PerceptionReq", "RequiredQuest", "IsHidden", "SublimeVariant", "Unknown3", "Unknown2" };

/// Links to `Quest`.
pub fn requiredQuest(self: @This()) excel.Link(sheets.Quest) {
    return .of(self.row.at(u32, 0));
}

/// Links to `GatheringItem`.
pub fn sublimeVariant(self: @This()) excel.Link(sheets.GatheringItem) {
    return .of(self.row.at(u32, 4));
}

/// Links to `Item` or `EventItem`, whichever has the row.
pub fn item(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `GatheringItemLevelConvertTable`.
pub fn gatheringItemLevel(self: @This()) excel.Link(sheets.GatheringItemLevelConvertTable) {
    return .of(self.row.at(u16, 12));
}

pub fn perceptionReq(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown2(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 18);
}

pub fn unknown4(self: @This()) bool {
    return self.row.bitAt(19, 0);
}

pub fn unknown5(self: @This()) bool {
    return self.row.bitAt(19, 1);
}

pub fn isHidden(self: @This()) bool {
    return self.row.bitAt(19, 2);
}
