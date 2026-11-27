//! `WKSAchievementRewardItem`, made from EXDSchema by tools/excel-sheets. Don't edit it.

const std = @import("std");
const excel = @import("excel");
const sheets = @import("root.zig");

const WKSAchievementRewardItem = @This();

pub const sheet_name = "WKSAchievementRewardItem";
pub const kind: excel.Header.Kind = .rows;
pub const columns_hash: u32 = 0x1b55da98;
pub const Sheet = excel.Typed(WKSAchievementRewardItem);

row: excel.Row,

/// Each column's name, in the header's order, like `Item[2].Count`.
pub const column_names = [_][]const u8{ "Item", "ToolClass", "Unknown2" };

/// Links to `Item`.
pub fn item(self: @This()) excel.Link(sheets.Item) {
    return .of(self.row.at(u32, 0));
}

/// Links to `WKSCosmoToolClass`.
pub fn toolClass(self: @This()) excel.Link(sheets.WKSCosmoToolClass) {
    return .of(self.row.at(u8, 4));
}

pub fn unknown2(self: @This()) u8 {
    return self.row.at(u8, 5);
}
