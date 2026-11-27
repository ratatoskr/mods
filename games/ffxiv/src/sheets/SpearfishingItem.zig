//! `SpearfishingItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const SpearfishingItem = @This();

pub const sheet_name = "SpearfishingItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x644e0d6c;
pub const Sheet = excel.Typed(SpearfishingItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Description", "Item", "GatheringItemLevel", "Expansion", "IsHidden", "FishingRecordType", "SpearfishingNotebook", "GatheringSubCategory", "IsInLog" };

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(i32, 4));
}

/// Links to `GatheringItemLevelConvertTable`.
pub fn gatheringItemLevel(self: @This()) excel.Link(sheets.GatheringItemLevelConvertTable) {
    return .of(self.row.at(u16, 8));
}

pub fn expansion(self: @This()) u16 {
    return self.row.at(u16, 10);
}

/// Links to `SpearfishingNotebook`.
pub fn spearfishingNotebook(self: @This()) excel.Link(sheets.SpearfishingNotebook) {
    return .of(self.row.at(u16, 12));
}

/// Links to `GatheringSubCategory`.
pub fn gatheringSubCategory(self: @This()) excel.Link(sheets.GatheringSubCategory) {
    return .of(self.row.at(u16, 14));
}

/// Links to `FishingRecordType`.
pub fn fishingRecordType(self: @This()) excel.Link(sheets.FishingRecordType) {
    return .of(self.row.at(u8, 16));
}

pub fn isHidden(self: @This()) bool {
    return self.row.bitAt(17, 0);
}

pub fn isInLog(self: @This()) bool {
    return self.row.bitAt(17, 1);
}
