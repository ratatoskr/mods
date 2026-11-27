//! `BannerFacial`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const BannerFacial = @This();

pub const sheet_name = "BannerFacial";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x5c0f5111;
pub const Sheet = excel.Typed(BannerFacial);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Emote", "UnlockCondition", "Unknown_70_1", "Unknown_70_2", "Unknown0", "SortKey" };

/// Links to `Emote`.
pub fn emote(self: @This()) excel.Link(sheets.Emote) {
    return .of(self.row.at(u16, 0));
}

/// Links to `BannerCondition`.
pub fn unlockCondition(self: @This()) excel.Link(sheets.BannerCondition) {
    return .of(self.row.at(u16, 2));
}

pub fn unknown_70_1(self: @This()) u16 {
    return self.row.at(u16, 4);
}

pub fn unknown_70_2(self: @This()) u16 {
    return self.row.at(u16, 6);
}

pub fn unknown0(self: @This()) u16 {
    return self.row.at(u16, 8);
}

pub fn sortKey(self: @This()) u8 {
    return self.row.at(u8, 10);
}
