//! `Achievement`, made from EXDSchema by tools/excel-sheets. Don't edit it.
//! Its column shown for a link to it is `Name`.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const Achievement = @This();

pub const sheet_name = "Achievement";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xe17ab03b;
pub const Sheet = excel.Typed(Achievement);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

pub fn description(self: @This()) []const u8 {
    return self.row.stringAt(4);
}

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 8));
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// Links by `Type`: 2 to `Achievement`, 3 to `ClassJob`, 6 to `Quest`, 7 to `ClassJob`, 8 to `Map`, 9 to `Quest`, 11 to `GrandCompany`, 14 to `InstanceContent`, 15 to `BeastTribe`, 18 to `GrandCompany`, 20 to `AetherCurrentCompFlgSet`, 24 to `Quest`.
pub fn key(self: @This()) i32 {
    return self.row.at(i32, 16);
}

pub const data_len = 8;
/// Links by `Type`: 2 to `Achievement`, 6 to `Quest`, 9 to `Quest`, 15 to `BeastReputationRank`, 20 to `AetherCurrentCompFlgSet`, 24 to `ClassJob` or `Quest`.
pub fn data(self: @This(), n0: usize) i32 {
    return self.row.at(i32, offsets_1[n0]);
}

/// Links to `Title`.
pub fn title(self: @This()) excel.Link(sheets.Title) {
    return .of(self.row.at(u16, 52));
}

pub fn order(self: @This()) u16 {
    return self.row.at(u16, 54);
}

/// Links to `AchievementCategory`.
pub fn achievementCategory(self: @This()) excel.Link(sheets.AchievementCategory) {
    return .of(self.row.at(u8, 56));
}

/// Links to `AchievementTarget`.
pub fn achievementTarget(self: @This()) excel.Link(sheets.AchievementTarget) {
    return .of(self.row.at(u8, 57));
}

pub fn unknown0(self: @This()) u8 {
    return self.row.at(u8, 58);
}

pub fn points(self: @This()) u8 {
    return self.row.at(u8, 59);
}

pub fn unknown1(self: @This()) u8 {
    return self.row.at(u8, 60);
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 61);
}

pub fn unknown3(self: @This()) u8 {
    return self.row.at(u8, 62);
}

pub fn unknown4(self: @This()) u8 {
    return self.row.at(u8, 63);
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 64);
}

pub fn unknown5(self: @This()) u8 {
    return self.row.at(u8, 65);
}

/// Links to `AchievementHideCondition`.
pub fn achievementHideCondition(self: @This()) excel.Link(sheets.AchievementHideCondition) {
    return .of(self.row.at(u8, 66));
}

const offsets_1 = [8]u16{ 20, 24, 28, 32, 36, 40, 44, 48 };
