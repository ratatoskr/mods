//! `WKSMissionToDo`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSMissionToDo = @This();

pub const sheet_name = "WKSMissionToDo";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x58da12d6;
pub const Sheet = excel.Typed(WKSMissionToDo);

row: excel.Row,

/// Links to `Action` or `ActionTransient`, whichever has the row.
pub fn temporaryAction(self: @This()) u32 {
    return self.row.at(u32, 0);
}

pub fn bronzeScore(self: @This()) u32 {
    return self.row.at(u32, 4);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 8);
}

pub const required_item_len = 3;
/// Links to `WKSItemInfo`.
pub fn requiredItem(self: @This(), n0: usize) excel.Link(sheets.WKSItemInfo) {
    return .of(self.row.at(u16, offsets_1[n0]));
}

pub const required_item_quantity_len = 3;
pub fn requiredItemQuantity(self: @This(), n0: usize) u16 {
    return self.row.at(u16, offsets_2[n0]);
}

pub fn requiredFishVariety(self: @This()) u16 {
    return self.row.at(u16, 24);
}

pub fn unknown10(self: @This()) u16 {
    return self.row.at(u16, 26);
}

pub fn unknown11(self: @This()) u16 {
    return self.row.at(u16, 28);
}

pub fn unknown12(self: @This()) u16 {
    return self.row.at(u16, 30);
}

/// Links to `WKSMissionMapMarker`.
pub fn mapMarker(self: @This()) excel.Link(sheets.WKSMissionMapMarker) {
    return .of(self.row.at(u16, 32));
}

pub fn unknown18(self: @This()) u16 {
    return self.row.at(u16, 34);
}

pub fn unknown19(self: @This()) u16 {
    return self.row.at(u16, 36);
}

/// Links to `WKSMissionText`.
pub fn wksMissionText(self: @This()) excel.Link(sheets.WKSMissionText) {
    return .of(self.row.at(u16, 38));
}

pub fn temporaryActionCount(self: @This()) u8 {
    return self.row.at(u8, 40);
}

pub fn unknown15(self: @This()) u8 {
    return self.row.at(u8, 41);
}

pub fn unknown16(self: @This()) u8 {
    return self.row.at(u8, 42);
}

pub fn requiredFishQuantity(self: @This()) u8 {
    return self.row.at(u8, 43);
}

pub fn missionType(self: @This()) u8 {
    return self.row.at(u8, 44);
}

const offsets_1 = [3]u16{ 12, 14, 16 };
const offsets_2 = [3]u16{ 18, 20, 22 };
