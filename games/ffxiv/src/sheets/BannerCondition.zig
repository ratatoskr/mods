//! `BannerCondition`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BannerCondition = @This();

pub const sheet_name = "BannerCondition";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xfb032b77;
pub const Sheet = excel.Typed(BannerCondition);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "UnlockType1", "UnlockCriteria1[0]", "UnlockCriteria1[1]", "UnlockType2", "UnlockCriteria2", "UnlockCriteria3", "UnlockCriteria4", "Unknown1", "PrerequisiteType", "Prerequisite", "UnlockHint", "Unknown0" };

pub const unlock_criteria1_len = 2;
/// Links by `UnlockType1`: 1 to `Quest`, 3 to `InstanceContent`, 4 to `InstanceContent`, 5 to `Emote`, 6 to `Companion`, 7 to `Mount`, 8 to `Ornament`.
pub fn unlockCriteria1(self: @This(), n0: usize) u32 {
    return self.row.at(u32, offsets_1[n0]);
}

/// Links by `UnlockType2`: 2 to `Quest`, 4 to `ENpcResident`, 5 to `Item`, 6 to `Item`, 7 to `Item`, 8 to `Item`, 11 to `Achievement`, 12 to `Item`, 13 to `ENpcBase`, 21 to `ENpcBase`.
pub fn unlockCriteria2(self: @This()) u32 {
    return self.row.at(u32, 8);
}

/// Links by `UnlockType2`: 4 to `Level`, 13 to `Level`, 21 to `Level`.
pub fn unlockCriteria3(self: @This()) u32 {
    return self.row.at(u32, 12);
}

/// Links by `UnlockType2`: 4 to `Item`, 21 to `Item`.
pub fn unlockCriteria4(self: @This()) u32 {
    return self.row.at(u32, 16);
}

pub fn unknown1(self: @This()) u32 {
    return self.row.at(u32, 20);
}

/// Links by `PrerequisiteType`: 1 to `Quest`, 3 to `InstanceContent`, 4 to `InstanceContent`, 5 to `Emote`, 6 to `Companion`, 7 to `Mount`, 8 to `Ornament`.
pub fn prerequisite(self: @This()) u32 {
    return self.row.at(u32, 24);
}

pub fn unlockType1(self: @This()) u8 {
    return self.row.at(u8, 28);
}

pub fn unlockType2(self: @This()) u8 {
    return self.row.at(u8, 29);
}

pub fn prerequisiteType(self: @This()) u8 {
    return self.row.at(u8, 30);
}

/// Links to `BannerObtainHintType`.
pub fn unlockHint(self: @This()) excel.Link(sheets.BannerObtainHintType) {
    return .of(self.row.at(u8, 31));
}

pub fn unknown0(self: @This()) bool {
    return self.row.bitAt(32, 0);
}

const offsets_1 = [2]u16{ 0, 4 };
