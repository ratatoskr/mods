//! `FishParameter`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Item`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const FishParameter = @This();

pub const sheet_name = "FishParameter";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x7c44029d;
pub const Sheet = excel.Typed(FishParameter);

row: excel.Row,

pub fn text(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn unknown_70_1(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

pub fn unknown_70_2(self: @This()) []const u8 {
    return self.row.stringAt(8);
}

pub fn unknown_70_3(self: @This()) []const u8 {
    return self.row.stringAt(12);
}

pub fn achievementCredit(self: @This()) u32 {
    return self.row.at(u32, 16);
}

/// Links to `EventItem` or `Item`, whichever has the row.
pub fn item(self: @This()) i32 {
    return self.row.at(i32, 20);
}

/// Links to `GatheringItemLevelConvertTable`.
pub fn gatheringItemLevel(self: @This()) excel.Link(sheets.GatheringItemLevelConvertTable) {
    return .of(self.row.at(u16, 24));
}

pub fn unknown1(self: @This()) u16 {
    return self.row.at(u16, 26);
}

/// Links to `FishingSpot`.
pub fn fishingSpot(self: @This()) excel.Link(sheets.FishingSpot) {
    return .of(self.row.at(u16, 28));
}

/// Links to `GatheringSubCategory`.
pub fn gatheringSubCategory(self: @This()) excel.Link(sheets.GatheringSubCategory) {
    return .of(self.row.at(u16, 30));
}

pub fn oceanStars(self: @This()) u8 {
    return self.row.at(u8, 32);
}

/// Links to `FishingRecordType`.
pub fn fishingRecordType(self: @This()) excel.Link(sheets.FishingRecordType) {
    return .of(self.row.at(u8, 33));
}

pub fn isHidden(self: @This()) bool {
    return self.row.bitAt(34, 0);
}

pub fn isInLog(self: @This()) bool {
    return self.row.bitAt(34, 1);
}
