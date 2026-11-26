//! `BannerTimeline`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BannerTimeline = @This();

pub const sheet_name = "BannerTimeline";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0xcadf9952;
pub const Sheet = excel.Typed(BannerTimeline);

row: excel.Row,

pub fn name(self: @This()) []const u8 {
    return self.row.stringAt(0);
}

/// Links by `Type`: 2 to `Action`, 11 to `Emote`, 20 to `ActionTimeline`.
pub fn additionalData(self: @This()) u32 {
    return self.row.at(u32, 4);
}

/// An icon's id, like 132122 for `ui/icon/132000/132122.tex`.
pub fn icon(self: @This()) i32 {
    return self.row.at(i32, 8);
}

/// Links to `BannerCondition`.
pub fn unlockCondition(self: @This()) excel.Link(sheets.BannerCondition) {
    return .of(self.row.at(u16, 12));
}

pub fn unknown_70_1(self: @This()) u16 {
    return self.row.at(u16, 14);
}

pub fn unknown_70_2(self: @This()) u16 {
    return self.row.at(u16, 16);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 18);
}

pub fn sortKey(self: @This()) u16 {
    return self.row.at(u16, 20);
}

pub fn @"type"(self: @This()) u8 {
    return self.row.at(u8, 22);
}

/// Links to `ClassJobCategory`.
pub fn acceptClassJobCategory(self: @This()) excel.Link(sheets.ClassJobCategory) {
    return .of(self.row.at(u8, 23));
}

pub fn category(self: @This()) u8 {
    return self.row.at(u8, 24);
}
